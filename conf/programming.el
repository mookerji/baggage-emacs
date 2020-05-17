;;; Language configurations

;; Along with editing.el, covers:
;; - code completion
;; - documentation (tooltips) (ish?)
;; - syntax checking, linting
;; - code navigation
;; - fast search across project
;; - compilation?
;; - go to definition
;; - Debugging

;; system, VC

(use-package diff-hl)

(use-package exec-path-from-shell)

(use-package forge)

(use-package git-timemachine)

(use-package gitattributes-mode)

(use-package gitconfig-mode)

(use-package gitignore-mode)

(use-package gist)

(use-package magit
  :defer 2
  :bind (("C-x g" . magit-status)))

;; languages

(use-package aggressive-indent
  :diminish
  :hook (emacs-lisp-mode . aggressive-indent-mode))

(use-package eldoc
  :config
  (add-hook 'emacs-lisp-mode-hook 'eldoc-mode))

(use-package flycheck
  :defer 5
  :config (global-flycheck-mode 1))

(use-package flycheck-pos-tip)

;; Setup via: https://www.mortens.dev/blog/emacs-and-the-language-server-protocol/
(use-package lsp-mode
  :config
  (add-hook 'rust-mode-hook #'lsp)
  (add-hook 'c++-mode-hook #'lsp)
  (add-hook 'c-mode-hook #'lsp)
  (setq lsp-prefer-flymake nil)
  (require 'lsp-clients)
  (setq lsp-clients-clangd-args '("-j=4" "-background-index" "-log=error"))
  :commands (lsp-mode lsp-mode-deferred))

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)

(use-package lsp-treemacs
  :commands lsp-treemacs-errors-list
  :config (lsp-treemacs-sync-mode 1))

(use-package lsp-ui
  :requires lsp-mode flycheck
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-use-childframe t
        lsp-ui-doc-position 'top
        lsp-ui-doc-include-signature t
        lsp-ui-sideline-enable nil
        lsp-ui-flycheck-enable t
        lsp-ui-flycheck-list-position 'right
        lsp-ui-flycheck-live-reporting t
        lsp-ui-peek-enable t
        lsp-ui-peek-list-width 60
        lsp-ui-peek-peek-height 25)
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  ;; See:
  ;; https://github.com/bbatsov/prelude/blob/master/modules/prelude-lsp.el#L42
  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
  (define-key lsp-ui-mode-map (kbd "C-c C-l .") 'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map (kbd "C-c C-l ?") 'lsp-ui-peek-find-references)
  (define-key lsp-ui-mode-map (kbd "C-c C-l r") 'lsp-rename)
  (define-key lsp-ui-mode-map (kbd "C-c C-l x") 'lsp-restart-workspace)
  (define-key lsp-ui-mode-map (kbd "C-c C-l w") 'lsp-ui-peek-find-workspace-symbol)
  (define-key lsp-ui-mode-map (kbd "C-c C-l i") 'lsp-ui-peek-find-implementation)
  (define-key lsp-ui-mode-map (kbd "C-c C-l d") 'lsp-describe-thing-at-point)
  (define-key lsp-ui-mode-map (kbd "C-c C-l e") 'lsp-execute-code-action))

(use-package lsp-ui-imenu
  :requires lsp-ui)

(use-package dap-mode)

(use-package dap-lldb)

(use-package company
  :hook (prog-mode . company-mode)
  :diminish
  :config
  (global-company-mode 1)
  (global-set-key (kbd "C-<tab>") 'company-complete)
  (setq company-idle-delay 0.0
        company-minimum-prefix-length 1
        company-show-numbers t
        company-tooltip-align-annotations t
        company-tooltip-flip-when-above t
        company-tooltip-limit 10))

(use-package company-lsp
  :requires company
  :after lsp-mode
  :config
  (require 'lsp-clients)
  (push 'company-lsp company-backends)
  (yas-minor-mode-on)
  (setq company-transformers nil
        company-lsp-async t
        company-lsp-cache-candidates nil))

;; C / C++

;; FIX
(use-package cc-mode
  :mode (("\\.h\\(h?\\|xx\\|pp\\)\\'" . c++-mode))
  :config
  (setq tab-width 2)
  (setq-default c-basic-offset 2))

(add-hook 'c-mode-hook
          (lambda ()
            (setq comment-start "//" comment-end   "")))

(use-package modern-cpp-font-lock
  :straight t
  :ensure t
  :hook (c++-mode . modern-c++-font-lock-mode))

;; Lifted from: https://eklitzke.org/smarter-emacs-clang-format
(defun clang-format-buffer-smart ()
  "Reformat buffer if .clang-format exists in the projectile root."
  (when (and (f-exists? (expand-file-name ".clang-format" (projectile-project-root))) (or (eq major-mode 'c-mode) (eq major-mode 'c++-mode)))
    (clang-format-buffer)))

(use-package clang-format
  :defer t
  :commands (clang-format-buffer clang-format-region)
  :hook (before-save . clang-format-buffer-smart))

(use-package cmake-font-lock
  :hook (cmake-mode . cmake-font-lock-activate))

(use-package cmake-mode
  :mode ("CMakeLists.txt" "\\.cmake\\'")
  :hook (cmake-mode .
                    (lambda()
                      (progn
                        (setq-local company-idle-delay nil)
                        (setq-local company-dabbrev-code-everywhere t)
                        (setq-local company-backends '(company-cmake company-files))))))

(use-package make-mode
  :config
  (whitespace-toggle-options '(tabs))
  (setq indent-tabs-mode t))

;; Protocol Buffers mode

;; FIX
(defconst my-protobuf-style
  '((c-basic-offset . 2)
    (indent-tabs-mode . nil)))

(add-hook 'protobuf-mode-hook
          (lambda () (c-add-style "my-style" my-protobuf-style t)))

(use-package protobuf-mode
  :mode ("\\.proto\\'" . protobuf-mode))

;; langauges: python

(use-package python-mode
  :mode "\\.py\\'"
  :interpreter "python3"
  :bind (:map python-mode-map
              ("C-c c")
              ("C-c C-z" . python-shell))
  :config
  (setq indent-tabs-mode nil)
  (subword-mode 1)
  (eldoc-mode 1))

;; languages: rust (Requires: rustc, cargo, rustfmt, rls)

(use-package cargo
  :hook (rust-mode . cargo-minor-mode))

(use-package rust-mode
  :mode "\\.rs\\'"
  :init
  (cargo-minor-mode 1)
  (subword-mode 1)
  (electric-pair-mode 1)
  (flycheck-mode 1)
  (yas-minor-mode-on)
  (eldoc-mode 1)
  (setq rust-format-on-save t))

(use-package flycheck-rust
  :config
  (with-eval-after-load 'rust-mode
    (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)))

;; Stan
;;
;; https://github.com/stan-dev/stan-mode

(use-package stan-mode
  :mode ("\\.stan\\'" . stan-mode)
  :hook (stan-mode . stan-mode-setup)
  :config (setq stan-indentation-offset 2))

(use-package company-stan
  :hook (stan-mode . company-stan-setup)
  :config (setq company-stan-fuzzy nil))

(use-package eldoc-stan
  :hook (stan-mode . eldoc-stan-setup))

(use-package flycheck-stan
  :hook (stan-mode . flycheck-stan-setup))

(use-package stan-snippets
  :hook (stan-mode . stan-snippets-initialize))

(use-package ac-stan
  :disabled t
  :hook (stan-mode . stan-ac-mode-setup))

;; languages: web and web markup (TODO)

;; languages: misc programming languages

(use-package go-mode
  :defer t
  :mode ("\\.go$" . go-mode))

(use-package haskell-mode
  :defer t
  :mode ("\\.hs\\'" . hs-mode))

(use-package lua-mode
  :mode "\\.lua\\'"
  :interpreter "lua")

;; languages: devops

(use-package bazel-mode
  :mode (("\\WORKSPACE\\'" . bazel-mode)
         ("\\BUILD\\'"     . bazel-mode)
         ("\\.bazel\\'"    . bazel-mode)
         ("\\.bzl\\'"      . bazel-mode)))


;; (use-package docker
;;   :bind ("C-c d" . docker)
;;   :diminish
;;   :init
;;   (use-package docker-image     :commands docker-images)
;;   (use-package docker-container :commands docker-containers)
;;   (use-package docker-volume    :commands docker-volumes)
;;   (use-package docker-network   :commands docker-containers)
;;   (use-package docker-machine   :commands docker-machines)
;;   (use-package docker-compose   :commands docker-compose))

(use-package docker-compose-mode
  :mode "docker-compose.*\.yml\\'")

(use-package dockerfile-mode
  :mode "Dockerfile[a-zA-Z.-]*\\'")

(use-package terraform-mode
  :mode "\.tf\\'")

;; languages: markup

(use-package json-mode
  :mode "\\.json\\'")

(use-package json-reformat
  :after json-mode)

(use-package markdown-mode
  :mode (("\\`README\\.md\\'" . gfm-mode)
         ("\\.md\\'"          . markdown-mode)
         ("\\.markdown\\'"    . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package textile-mode)

(use-package toml-mode)

(use-package yaml-mode
  :mode ("\\.ya?ml\\'" . yaml-mode))

(provide 'programming)
