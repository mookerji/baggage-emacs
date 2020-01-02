;; Emacs config entry point
;;
;; Entirely based on:
;; - https://github.com/jwiegley/dot-emacs/blob/master/init.el

(defvar file-name-handler-alist-old file-name-handler-alist)

(setq package-enable-at-startup nil
      file-name-handler-alist nil
      message-log-max 16384
      gc-cons-threshold 402653184
      gc-cons-percentage 0.6
      auto-window-vscroll nil
      inhibit-startup-message t)

(add-hook 'after-init-hook
          `(lambda ()
             (setq file-name-handler-alist file-name-handler-alist-old
                   gc-cons-threshold 800000
                   gc-cons-percentage 0.1)
             (garbage-collect)) t)

(add-to-list 'load-path (expand-file-name "conf" user-emacs-directory))

(require 'settings)
(require 'packages)
(require 'fonts)
(require 'appearance)
(require 'editing)
(require 'programming)

(server-start)
