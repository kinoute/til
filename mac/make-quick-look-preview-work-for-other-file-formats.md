# Make Quick Look Preview work for other file formats 

Quick Look offers a fast and full-size preview of a lot of files by default:
text, images, pdf... Just by using the `space` key, you can preview a file in
the Finder without really opening it.

You can enhance this feature of macOS by installing new _generators_. A
generator is a plugin that will extend Quick Look to support new type of files.

![](https://github.com/sindresorhus/quick-look-plugins/raw/master/screenshots/QuickLookJSON.png)

Here is a list of interesting generators you can install with `brew`:

```bash
# better syntax highlighting for source codes
brew cask install qlcolorcode
# preview plain text files without an extension
brew cask install qlstephen
# preview markdown files
brew cask install qlmarkdown
# preview json files nicely
brew cask install quicklook-json
# preview .patch files
brew cask install qlprettypatch
# show screenshots and infos of a video
brew cask install qlvideo
# show the content of an Apple Installer package (.pkg)
brew cask install suspicious-package
# preview WebP images
brew cask install webpquicklook
# preview .csv files
brew cask install quicklook-csv
# see ipynb jupyter notebooks
brew cask install jupyter-notebook-viewer
```

You can find other generators on this repo:
https://github.com/sindresorhus/quick-look-plugins
