sync:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	curl -Ss https://raw.githubusercontent.com/gpakosz/.tmux/master/.tmux.conf -o $(PWD)/.tmux.conf
	mkdir -p ~/.config/git
	[ -f ~/.vimrc ] || ln -s $(PWD)/.vimrc ~/.vimrc
	[ -f ~/.ideavimrc ] || ln -s $(PWD)/.ideavimrc ~/.ideavimrc
	[ -f ~/.bashrc ] || ln -s $(PWD)/.bashrc ~/.bashrc
	[ -f ~/.zshrc ] || ln -s $(PWD)/.zshrc ~/.zshrc
	[ -f ~/.zsh_private ] || ln -s $(PWD)/.zsh_private ~/.zsh_private
	[ -f ~/.tmux.conf ] || ln -s $(PWD)/.tmux.conf ~/.tmux.conf
	[ -f ~/.tmux.conf.local ] || ln -s $(PWD)/.tmux.conf.local ~/.tmux.conf.local
	[ -f ~/.tigrc ] || ln -s $(PWD)/tigrc ~/.tigrc
	[ -f ~/.gitconfig ] || ln -s $(PWD)/git/.gitconfig ~/.gitconfig
	[ -f ~/.git_commit ] || ln -s $(PWD)/git/.git_commit ~/.git_commit
	[ -f ~/.config/git/ignore ] || ln -s $(PWD)/git/.gitignore_global ~/.config/git/ignore
	[ -f ~/.config/starship.toml ] || ln -s $(PWD)/starship.toml ~/.config/starship.toml

clean:
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

brew:
	brew bundle

setup: clean sync brew

.PHONY: clean sync brew
