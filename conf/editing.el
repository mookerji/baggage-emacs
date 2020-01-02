;; Emacs-wide keybinding, navigation, editing, and writing settings

;; Aliases and bindings

(defalias 'cp 'copy-file)
(defalias 'mkdir 'make-directory)
(defalias 'mv 'rename-file)
(defalias 'qrr 'query-replace-regexp)
(defalias 'rm 'delete-file)
(defalias 'rmdir 'delete-directory)

(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-h" 'delete-backward-char)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)
(global-set-key "\C-x:"      'goto-line)
(global-set-key "\M-^" 'query-replace-regexp)
(global-set-key [f5] 'call-last-kbd-macro)

; Use ibuffer instead
(defalias 'list-buffers 'ibuffer)
(iswitchb-mode 1)

;; Defaults

(setq-default indent-tabs-mode nil)

(setq save-interprogram-paste-before-kill t
      apropos-do-all t
      mouse-yank-at-point t
      require-final-newline t)

;; Navigation

(use-package which-key)
(use-package guide-key)
(use-package hydra)
                                        ; TODO: remove?
;; (use-package ido
;;   :config
;;   (setq ido-enable-flex-matching t)
;;   (ido-mode 1))
;;(use-package ido-at-point)
;;(use-package ido-completing-read+)
;;(use-package ido-vertical-mode)
(use-package projectile
  :config
  (projectile-global-mode)
  (setq projectile-enable-caching t))
; From: https://github.com/Alexander-Miller/treemacs
(use-package treemacs
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-directory-name-transformer    #'identity
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-extension-regex          treemacs-last-period-regex-value
          treemacs-file-follow-delay             0.2
          treemacs-file-name-transformer         #'identity
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-asc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-width                         35)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)
    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-projectile
  :after treemacs projectile)
(use-package treemacs-icons-dired
  :after treemacs dired
  :config (treemacs-icons-dired-mode))
(use-package treemacs-magit
  :after treemacs magit)

(use-package ivy
  :diminish
  :demand t

  :bind (("C-x b" . ivy-switch-buffer)
         ("C-x B" . ivy-switch-buffer-other-window)
         ("M-H"   . ivy-resume))

  :bind (:map ivy-minibuffer-map
              ("<tab>" . ivy-alt-done)
              ("SPC"   . ivy-alt-done-or-space)
              ("C-d"   . ivy-done-or-delete-char)
              ("C-i"   . ivy-partial-or-done)
              ("C-r"   . ivy-previous-line-or-history)
              ("M-r"   . ivy-reverse-i-search))

  :bind (:map ivy-switch-buffer-map
              ("C-k" . ivy-switch-buffer-kill))

  :custom
  (ivy-dynamic-exhibit-delay-ms 200)
  (ivy-height 10)
  (ivy-initial-inputs-alist nil t)
  (ivy-magic-tilde nil)
  (ivy-re-builders-alist '((t . ivy--regex-ignore-order)))
  (ivy-use-virtual-buffers t)
  (ivy-wrap t)

  :config
  (ivy-mode 1)
  (ivy-set-occur 'ivy-switch-buffer 'ivy-switch-buffer-occur))

(use-package ivy-rich
  :init
  (setq ivy-rich-display-transformers-list
        '(counsel-M-x
          (:columns
           ((counsel-M-x-transformer (:width 35))
            (ivy-rich-counsel-function-docstring (:width 80 :face font-lock-doc-face))))
          package-install
          (:columns
           ((ivy-rich-candidate (:width 25))
            (ivy-rich-package-version (:width 12 :face font-lock-comment-face))
            (ivy-rich-package-archive-summary (:width 7 :face font-lock-builtin-face))
            (ivy-rich-package-install-summary (:width 80 :face font-lock-doc-face))))))
  :config
  (ivy-rich-mode +1)
  (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line))

(use-package swiper
  :after ivy
  :bind (:map isearch-mode-map
              ("C-o" . swiper-from-isearch)))

(use-package counsel
  :after ivy
  :demand t
  :diminish
  :config
  (setq counsel-git-grep-cmd-default
        "git --no-pager grep --full-name -n -C4 --no-color --threads 4 -i -e \"%s\""))

;; Generic code editing

(use-package paredit
  :diminish
  :hook ((lisp-mode emacs-lisp-mode) . paredit-mode)
  :bind (:map paredit-mode-map
              ("[")
              ("M-k"   . paredit-raise-sexp)
              ("M-I"   . paredit-splice-sexp)
              ("C-M-l" . paredit-recentre-on-sexp)
              ("C-c ( n"   . paredit-add-to-next-list)
              ("C-c ( p"   . paredit-add-to-previous-list)
              ("C-c ( j"   . paredit-join-with-next-list)
              ("C-c ( J"   . paredit-join-with-previous-list))
  :bind (:map lisp-mode-map       ("<return>" . paredit-newline))
  :bind (:map emacs-lisp-mode-map ("<return>" . paredit-newline))
  :hook (paredit-mode
         . (lambda ()
             (unbind-key "M-r" paredit-mode-map)
             (unbind-key "M-s" paredit-mode-map)))
  :config
  (require 'eldoc)
  (eldoc-add-command 'paredit-backward-delete
                     'paredit-close-round))

(use-package smartparens)
(use-package yasnippet
  :config (add-hook 'prog-mode-hook 'yas-minor-mode))
(use-package yasnippet-snippets)

;; text editing

(use-package auto-dictionary)
(use-package flyspell)
(use-package flyspell-correct)
(use-package format-all)
(use-package lorem-ipsum)
(use-package move-text)
(use-package shell-command)
(use-package string-edit)
(use-package undo-tree)
(use-package whitespace-cleanup-mode)

;; search

(use-package ripgrep)
(use-package wgrep)

;; Hooks

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(provide 'editing)
