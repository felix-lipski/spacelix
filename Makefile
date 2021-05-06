export:
	nix build .#export
xresources:
	cp -r result/xresources xresources
clean:
	sudo rm -drf xresources
