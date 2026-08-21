#!/usr/bin/env bash
# yabai layout policy:
#   - External displays: bsp (auto-tiling).
#   - Built-in MacBook display: float layout + manage=off (fully unmanaged).
# Built-in detection uses CoreGraphics (CGDisplayIsBuiltin), so it works the
# same with the lid open or closed and needs no manual UUID bookkeeping.

set -euo pipefail

export PATH="/opt/homebrew/bin:$HOME/.local/share/mise/shims:$PATH"

RULE_LABEL="builtin-unmanage"

yabai -m rule --remove "$RULE_LABEL" 2>/dev/null || true

displays=$(yabai -m query --displays)

set_layout_for_display() {
  local idx="$1" layout="$2"
  printf '%s' "$displays" \
    | jq -r --arg i "$idx" '.[] | select(.index == ($i | tonumber)) | .spaces[]' \
    | while read -r sp; do
        yabai -m config --space "$sp" layout "$layout"
      done
}

BUILTIN_UUID=$(/usr/bin/swift - <<'SWIFT' 2>/dev/null || true
import AppKit
import Foundation
var count: UInt32 = 0
CGGetActiveDisplayList(0, nil, &count)
var ids = [CGDirectDisplayID](repeating: 0, count: Int(count))
CGGetActiveDisplayList(count, &ids, &count)
for id in ids where CGDisplayIsBuiltin(id) == 1 {
    if let uuidRef = CGDisplayCreateUUIDFromDisplayID(id)?.takeRetainedValue(),
       let s = CFUUIDCreateString(nil, uuidRef) as String? {
        print(s); break
    }
}
SWIFT
)
BUILTIN_UUID=$(printf '%s' "${BUILTIN_UUID:-}" | tr -d '[:space:]')

BUILTIN_IDX=""
if [[ -n "$BUILTIN_UUID" ]]; then
  BUILTIN_IDX=$(printf '%s' "$displays" \
    | jq -r --arg u "$BUILTIN_UUID" '.[] | select(.uuid == $u) | .index')
fi

# Every external display gets bsp.
printf '%s' "$displays" \
  | jq -r --arg ex "${BUILTIN_IDX:-}" '.[] | select(.index != ($ex | tonumber? // -1)) | .index' \
  | while read -r idx; do
      set_layout_for_display "$idx" bsp
    done

# No built-in active — done.
[[ -n "$BUILTIN_IDX" ]] || exit 0

# Built-in: float layout + unmanage rule.
set_layout_for_display "$BUILTIN_IDX" float

yabai -m rule --add label="$RULE_LABEL" app=".*" display="$BUILTIN_IDX" manage=off
yabai -m rule --apply "$RULE_LABEL"
