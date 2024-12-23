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
;; (global-set-key "\C-h" 'delete-backward-char)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)
(global-set-key "\C-x:"      'goto-line)
(global-set-key "\M-^" 'query-replace-regexp)
(global-set-key [f5] 'call-last-kbd-macro)

;; Use ibuffer instead

(defalias 'list-buffers 'ibuffer)

(iswitchb-mode 1)

;; (use-package ibuffer-projectile
;;   :ensure t
;;   :init
;;   (add-hook 'ibuffer-hook
;;             (lambda ()
;;               (ibuffer-projectile-set-filter-groups)
;;               (unless (eq ibuffer-sorting-mode 'alphabetic)
;;                 (ibuffer-do-sort-by-alphabetic)))))

;; Defaults

;; TODO(mookerji): Move this to an use-package emacs config

(setq-default indent-tabs-mode nil)

(setq save-interprogram-paste-before-kill t
      apropos-do-all t
      mouse-yank-at-point t
      require-final-newline t
      auto-save-interval 64
      auto-save-timeout 2)

;; Navigation

;; (use-package which-key
;;   :init
;;   (which-key-mode)
;;   :config
;;   (which-key-setup-side-window-right-bottom)
;;   (setq which-key-sort-order 'which-key-key-order-alpha
;;         which-key-side-window-max-width 0.33
;;         which-key-idle-delay 0.05)
;;   :diminish which-key-mode)

(use-package guide-key)

(use-package hydra)

(use-package vertico
  :init
  (vertico-mode)
  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  ;; (setq vertico-cycle t)
  )

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

;; Optionally use the `orderless' completion style.
(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; A few more useful configurations...

(use-package swiper
  :after ivy
  :bind (:map isearch-mode-map
              ("C-o" . swiper-from-isearch)))

(use-package counsel
  :after ivy
  :demand t
  :diminish
  :bind (("C-*"     . counsel-org-agenda-headlines)
         ("C-x C-f" . counsel-find-file)
         ("C-c e l" . counsel-find-library))
  :config
  (setq counsel-git-grep-cmd-default
        "git --no-pager grep --full-name -n -C4 --no-color --threads 4 -i -e \"%s\""))

(use-package counsel-osx-app
  :commands counsel-osx-app
  :config
  (setq counsel-osx-app-location
        (list "/Applications"
              (expand-file-name "~/Applications"))))

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

(use-package super-save
  :diminish
  :commands super-save-mode
  :config
  (super-save-mode 1)
  (setq auto-save-default nil)
  (setq super-save-auto-save-when-idle t))


(use-package aggressive-fill-paragraph
  :disabled t
  :defer t
  :commands aggressive-fill-paragraph-mode)

(use-package csv-mode
  :mode "\\.csv\\'")


(use-package tree-sitter-langs
  :ensure t
  :defer t)

;; brew install libgccjit
(use-package tree-sitter
  :ensure t
  :after tree-sitter-langs
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))


;; search

(use-package ripgrep)

(use-package wgrep)

(use-package dumb-jump
  :init
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  (setq xref-show-definitions-function #'xref-show-definitions-completing-read))

;; Hooks

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Emoji?

(use-package emojify)
;; (add-hook 'after-init-hook #'global-emojify-mode)


;; Example configuration for Consult
(use-package consult
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; By default `consult-project-function' uses `project-root' from project.el.
  ;; Optionally configure a different project root function.
  ;;;; 1. project.el (the default)
  ;; (setq consult-project-function #'consult--default-project--function)
  ;;;; 2. vc.el (vc-root-dir)
  ;; (setq consult-project-function (lambda (_) (vc-root-dir)))
  ;;;; 3. locate-dominating-file
  ;; (setq consult-project-function (lambda (_) (locate-dominating-file "." ".git")))
  ;;;; 4. projectile.el (projectile-project-root)
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-function (lambda (_) (projectile-project-root)))
  ;;;; 5. No project support
  ;; (setq consult-project-function nil)
  )

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

(setq project-vc-extra-root-markers '("Cargo.toml"))


;;
(use-package corfu
  :demand t
  :bind (("M-/" . completion-at-point)
         :map corfu-map
         ("C-n"      . corfu-next)
         ("C-p"      . corfu-previous)
         ("<escape>" . corfu-quit)
         ("<return>" . corfu-insert)
         ("M-d"      . corfu-info-documentation)
         ("M-l"      . corfu-info-location)
         ("M-."      . corfu-move-to-minibuffer))
  :custom
  ;; Works with `indent-for-tab-command'. Make sure tab doesn't indent when you
  ;; want to perform completion
  (tab-always-indent 'complete)
  (completion-cycle-threshold nil)      ; Always show candidates in menu

  ;; Only use `corfu' when calling `completion-at-point' or
  ;; `indent-for-tab-command'
  (corfu-auto nil)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.25)
  (corfu-min-width 80)
  (corfu-max-width corfu-min-width)     ; Always have the same width
  (corfu-count 14)
  (corfu-scroll-margin 4)
  (corfu-cycle nil)

  ;; `nil' means to ignore `corfu-separator' behavior, that is, use the older
  ;; `corfu-quit-at-boundary' = nil behavior. Set this to separator if using
  ;; `corfu-auto' = `t' workflow (in that case, make sure you also set up
  ;; `corfu-separator' and a keybind for `corfu-insert-separator', which my
  ;; configuration already has pre-prepared). Necessary for manual corfu usage with
  ;; orderless, otherwise first component is ignored, unless `corfu-separator'
  ;; is inserted.
  (corfu-quit-at-boundary nil)
  (corfu-separator ?\s)            ; Use space
  (corfu-quit-no-match 'separator) ; Don't quit if there is `corfu-separator' inserted
  (corfu-preview-current 'insert) ; Preview first candidate. Insert on input if only one
  (corfu-preselect-first t)       ; Preselect first candidate?

  ;; Other
  ;; Already use corfu-popupinfo
  (corfu-echo-documentation nil))

;; setup emark about somepoint?

;; org mode
;;
;; - https://orgmode.org/worg/org-tutorials/orgtutorial_dto.html
;; - https://github.com/james-stoup/emacs-org-mode-tutorial
;; - https://github.com/jwiegley/dot-emacs/blob/master/init.org#org-mode

(use-package org-super-agenda
  :after org
  :custom
  (org-super-agenda-groups '((:auto-tags t)))
  (org-super-agenda-header-separator "")
  (org-super-agenda-hide-empty-groups t)
  :config
  (org-super-agenda-mode))

(defun fix-org-headers ()
  (dolist (face '(org-level-1
                  org-level-2
                  org-level-3
                  org-level-4
                  org-level-5))
    (set-face-attribute face nil :family "Inconsolata" :weight 'normal :height 1.0)))

(use-package org
  :init
  (add-hook 'org-mode-hook #'fix-org-headers)
  (add-hook 'org-mode-hook 'visual-line-mode)
  (add-hook 'org-mode-hook 'org-indent-mode)
  :config
  (add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
  (setq org-agenda-files '("~/projects/personal/notes/diary" "~/projects/span/notes"))
  (setq org-todo-keywords '((sequence "TODO" "IN-PROGRESS" "BLOCKED" "DONE" "SKIP")))
  (setq org-todo-keyword-faces
        '(
          ("IN-PROGRESS" :foreground "orange" :weight bold)
          ("BLOCKED" :foreground "red" :weight bold)
          ("DONE" :foreground "brown" :weight bold)
          ("SKIP" :foreground "brown" :weight bold))
        )
  )


(use-package org-roam
  :after org)

;; (use-package org-ai
;;   :ensure t
;;   :commands (org-ai-mode
;;              org-ai-global-mode)
;;   :init
;;   (add-hook 'org-mode-hook #'org-ai-mode)
;;   (org-ai-global-mode)
;;   :config
;;   (setq org-ai-openai-api-token
;;         (or
;;          (getenv "OPENAI_KEY") "OPENAI_KEY not set"))
;;   (setq org-ai-default-chat-model "gpt-4o"))


(use-package org-ai
  :ensure t
  :commands (org-ai-mode
             org-ai-global-mode)
  :init
  (add-hook 'org-mode-hook #'org-ai-mode)
  (org-ai-global-mode)
  :config
  (setq org-ai-auto-fill t)
  (setq org-ai-anthropic-api-version "2023-06-01")
  (setq org-ai-service 'anthropic)
  (setq org-ai-default-chat-model "claude-3-5-sonnet-20241022")
  (setq org-ai-openai-api-token (or (getenv "ANTHROPIC_KEY") "ANTHROPIC_KEY not set"))
  ;; (setq org-ai-service 'openai)
  ;; (setq org-ai-default-chat-model "gpt-4o")
  ;; (setq org-ai-openai-api-token
  ;;       (or
  ;;        (getenv "OPENAI_KEY") "OPENAI_KEY not set"))
  )


;; Installed for copilot stuff

(use-package gptel
  :ensure t
  :config
  (setq gptel-api-key (or (getenv "ANTHROPIC_KEY") "ANTHROPIC_KEY not set"))
  (setq gptel-model "claude-3-5-sonnet-20241022"))


(use-package editorconfig :ensure t)
(use-package company :ensure t)

(provide 'editing)
