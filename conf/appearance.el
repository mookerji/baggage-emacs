;;; Emacs-wide UI settings

;; Packages!

(use-package all-the-icons
  :custom (all-the-icons-scale-factor 0.5))
(use-package diminish)
(use-package fill-column-indicator)
(use-package highlight-escape-sequences)
(use-package rainbow-delimiters
  :init (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))
;; (use-package solarized-theme)
(use-package zoom)

;; Manually loaded since solarized-emacs somehow is unavailable (?) in Melpa
(add-to-list 'load-path (expand-file-name "local/solarized-emacs" user-emacs-directory))
(require 'solarized)
(load-theme 'solarized-dark t)


;; Buffers

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; UI

(setq-default fill-column 80)
;; (load-theme 'solarized-dark t)


(global-display-line-numbers-mode 1)
(column-number-mode 1)
(size-indication-mode 1)
(global-auto-revert-mode 1)
(global-hl-line-mode 1)
(show-paren-mode 1)

;; Workspace saving

(require 'desktop)
(setq desktop-path (list "~/.emacs.d/"))
(desktop-save-mode 1)

(use-package saveplace)
(setq save-place-file (concat user-emacs-directory "places"))

(save-place-mode t)

;; Stuff to disable

(unless (eq window-system 'ns)
  (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
(when (fboundp 'horizontal-scroll-bar-mode)
  (horizontal-scroll-bar-mode -1))

; Dispable scrolling in the minibuffer
(set-window-scroll-bars (minibuffer-window) nil nil)

;; Warnings

(setq large-file-warning-threshold 100000000)
(setq visible-bell 1)
(setq ring-bell-function 'ignore)
(setq redisplay-dont-pause t
      scroll-margin 1
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)

(setq mouse-wheel-follow-mouse 't)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))

;; Cleanup

(use-package midnight
  :config
  (midnight-mode t)
  (midnight-delay-set 'midnight-delay 18000))

(provide 'appearance)
