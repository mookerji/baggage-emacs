;; Setup Emacs use-package and other utilities

(require 'package)

(setq package-enable-at-startup nil)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(setq package-pinned-packages '())

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq load-prefer-newer t)

;; By default, ensure that all packages are installed.

(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; generic / Emacs
(use-package async)
(use-package osx-lib)
(use-package restart-emacs)

;; Use explicit warnings
(setq byte-compile-warnings '(byte-compile-warnings
                              callargs
                              free-vars
                              interactive-only
                              lexical
                              lexical-dynamic
                              make-local
                              mapcar
                              noruntime
                              not-unused
                              obsolete
                              redefine
                              suspicious
                              unresolved))

(provide 'packages)
