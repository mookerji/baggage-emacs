## Personal Emacs Configuration

To setup:

```
$ mkdir -p ~/.emacs.d/
$ cd ~/.emacs.d/
$ git clone git@github.com:mookerji/baggage-emacs.git .
```

In `~/.emacs`:

```
(require 'package)
(package-initialize)
(load "~/.emacs.d/init.el")
```

Prerequisites:

- [Inconsolata](https://fonts.google.com/specimen/Inconsolata)

NOTES:
- Tested with [Emacs for OSX](https://emacsformacosx.com/).
