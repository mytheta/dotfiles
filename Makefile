sync:
	curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	mkdir -p ~/.config/git
	mkdir -p ~/.config/nvim
	[ -f ~/.config/nvim/init.lua ] || ln -s $(PWD)/init.lua ~/.config/nvim/init.lua
	[ -f ~/.vimrc ] || ln -s $(PWD)/.vimrc ~/.vimrc
	ln -s ~/.config/nvim ~/.vim
	[ -f ~/.ideavimrc ] || ln -s $(PWD)/.ideavimrc ~/.ideavimrc
	[ -f ~/.zshrc ] || ln -s $(PWD)/.zshrc ~/.zshrc
	[ -f ~/.zsh_private ] || ln -s $(PWD)/.zsh_private ~/.zsh_private
	[ -f ~/.tmux.conf ] || ln -s $(PWD)/.tmux.conf ~/.tmux.conf
	[ -f ~/.tigrc ] || ln -s $(PWD)/.tigrc ~/.tigrc
	[ -f ~/.gitconfig ] || ln -s $(PWD)/git/.gitconfig ~/.gitconfig
	[ -f ~/.git_commit ] || ln -s $(PWD)/git/.git_commit ~/.git_commit
	[ -f ~/.config/git/ignore ] || ln -s $(PWD)/git/.gitignore_global ~/.config/git/ignore
	[ -f ~/.config/starship.toml ] || ln -s $(PWD)/starship.toml ~/.config/starship.toml
	mkdir -p ~/.config/mise
	[ -f ~/.config/mise/config.toml ] || ln -s $(PWD)/mise.toml ~/.config/mise/config.toml
	mkdir -p ~/.config/yabai
	[ -f ~/.config/yabai/yabairc ] || ln -s $(PWD)/yabai/yabairc ~/.config/yabai/yabairc
	[ -f ~/.config/yabai/gate-builtin.sh ] || ln -s $(PWD)/yabai/gate-builtin.sh ~/.config/yabai/gate-builtin.sh

clean:
	rm -f ~/.config/nvim/init.lua
	rm -f ~/.config/nvim/init.vim
	rm -f ~/.vimrc
	rm -f ~/.ideavimrc
	rm -f ~/.bashrc
	rm -f ~/.zshrc
	rm -f ~/.zsh_private
	rm -f ~/.tmux.conf
	rm -f ~/.tmux.conf.local
	rm -f ~/.tigrc
	rm -rf ~/.config/git
	rm -f ~/.config/starship.toml
	rm -f ~/.git_commit
	rm -f ~/.gitconfig
	rm -rf ~/.vim
	rm -f ~/.config/mise/config.toml
	rm -f ~/.config/yabai/yabairc
	rm -f ~/.config/yabai/gate-builtin.sh

brew:
	brew bundle

# mise 本体は brew ではなく公式インストーラで ~/.local/bin へ入れる
# (brew 版と二重に入ると PATH 解決が読みにくくなるため)
mise:
	command -v mise >/dev/null || curl https://mise.run | sh
	mise install

setup: clean sync

.PHONY: clean sync brew mise
