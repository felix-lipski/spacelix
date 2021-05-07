export:
	nix build .#export
xresources:
	cp -r result/xresources xresources
pywal:
	cp -r result/pywal pywal

clean:
	sudo rm -drf xresources
	sudo rm -drf pywal
