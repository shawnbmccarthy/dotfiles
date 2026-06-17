# README

this is a riff on sddm themes from [here](https://github.com/topics/sddm-theme), 
i used the basics as an example for learning qt & qml.

## dr who images
for all images created by the artist, the ask is simple, go 
download the image from where the user is hosting the file. have 
a look around you might see other works they created that you 
like.

1. [dalek black bg](https://wallpapersafari.com/w/vh32Is): i found the image here

## run

Test on your working desktop (uses the theme folder you point at):

```
sddm-greeter-qt6 --test-mode --theme /path/to/sddm-drwho-theme
```

Leave `ScreenHeight` / `ScreenWidth` at `0` in `Themes/*.conf` so the
greeter matches your real display. Hard-coding a size (e.g. 2880×1920)
makes test mode and the live login screen scale differently.

After editing the theme, sync the installed copy if SDDM runs from
`/usr/share/sddm/themes/sddm-drwho-theme/`.

## todo
still learning a bit

* what are the fun things to do (animations & fonts)
