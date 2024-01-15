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

(use-package gitattributes-mode)

(use-package gitconfig-mode)

(use-package gitignore-mode)

;; Excluded for recursive load?
;; (use-package gist)

(use-package magit
  :defer 2
  :bind (("C-x g" . magit-status))
  :config
  (setq magit-view-git-manual-method 'man)
  :custom
  (magit-diff-refine-hunk t))

;; languages

(use-package aggressive-indent
  :diminish
  :hook ((cpp-mode emacs-lisp-mode) . aggressive-indent-mode))

(use-package eldoc
  :config
  (add-hook 'emacs-lisp-mode-hook 'eldoc-mode))

(global-eldoc-mode -1) 

(use-package flycheck
  :defer 5)

(use-package flycheck-pos-tip)

;; Setup via: https://www.mortens.dev/blog/emacs-and-the-language-server-protocol/
;; (use-package lsp-mode
;;   :config
;;   (add-hook 'rust-mode-hook #'lsp)
;;   (add-hook 'c++-mode-hook #'lsp)
;;   (add-hook 'c-mode-hook #'lsp)
;;   (setq lsp-prefer-flymake nil)
;;   (require 'lsp-clients)
;;   (setq lsp-clients-clangd-args '("-j=4" "-background-index" "-log=error" "--suggest-missing-includes" "--header-insertion=iwyu" "--clang-tidy" "--resource-dir=/usr/local/opt/llvm/include/c++/v1/"))
;;   :commands (lsp-mode lsp-mode-deferred))

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)

(use-package lsp-treemacs
  :commands lsp-treemacs-errors-list
  :config (lsp-treemacs-sync-mode 1))

(use-package lsp-ui
  :requires lsp-mode flycheck
  :config
  (setq lsp-ui-doc-enable nil
        lsp-ui-doc-use-childframe t
        lsp-ui-doc-position 'top
        lsp-ui-doc-include-signature t
        lsp-ui-sideline-delay 0.4
        lsp-ui-sideline-enable nil
        lsp-ui-sideline-show-hover t
        lsp-ui-sideline-show-diagnostics t
        lsp-ui-flycheck-enable nil
        lsp-ui-flycheck-list-position 'right
        lsp-ui-flycheck-live-reporting nil
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

(use-package dap-mode)

(defvar company-mode/enable-yas t
  "Enable yasnippet for all backends.")

;; TODO: can this be done with pushd to company-backends

;; (use-package company-lsp
;;   :requires company
;;   :after lsp-mode
;;   :config
;;   (require 'lsp-clients)
;;   (push 'company-lsp company-backends)
;;   (yas-minor-mode-on)
;;   (setq company-transformers nil
;;         company-lsp-async t
;;         company-lsp-cache-candidates nil))

;; C / C++

;; FIX
(use-package cc-mode
  :mode (("\\.h\\(h?\\|xx\\|pp\\)\\'" . c++-mode))
  :config
  (flycheck-mode 1)
  (setq tab-width 2)
  (setq-default c-basic-offset 2))

(add-hook 'c-mode-hook
          (lambda ()
            (setq comment-start "//" comment-end   "")))

(use-package modern-cpp-font-lock
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
  :mode ("CMakeLists.txt" "\\.cmake\\'"))

(use-package make-mode
  :config
  (whitespace-toggle-options '(tabs))
  (setq indent-tabs-mode t))

(use-package company-c-headers
  :after company
	:commands (company-c-headers
             company-c-headers-setup)
	:hook ((c++-mode . company-c-headers-setup)
         (c-mode . company-c-headers-setup))
  :config
	(defun company-c-headers-setup ()
		(add-to-list 'company-c-headers-path-system "/usr/local/opt/llvm/include/c++/v1/")
		;; (require 'company-clang)
		;; (setq company-clang-arguments '("-std=c++17"))
		;; (add-to-list 'company-backends 'company-clang)
		(add-to-list 'company-backends 'company-c-headers)))

(use-package disaster
  :defer t
  :commands disaster)

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
  (define-key python-mode-map (kbd "C-c C-p") 'undefined)
  (setq indent-tabs-mode nil)
  (subword-mode 1)
  (company-mode -1)
  (eldoc-mode -1))

;; languages: rust (Requires: rustc, cargo, rustfmt, rls)

(use-package cargo
  :hook (rust-mode . cargo-minor-mode))

(use-package rust-mode
  :mode "\\.rs\\'"
  :init
  (cargo-minor-mode 1)
  (subword-mode 1)
  (electric-pair-mode 1)
  ;; (flycheck-mode 1)
  (eldoc-mode -1)
  (setq rustic-lsp-client 'eglot)
  (setq rust-format-on-save nil))

(use-package flycheck-rust
  :config
  (with-eval-after-load 'rust-mode
    (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)))

;; Requires installation of rust-analyzer:
;; $ git clone https://github.com/rust-lang/rust-analyzer.git && cd rust-analyzer
;; $ cargo xtask install --server
;; or $ rustup component add rust-analyzer?

(use-package rustic
  :init
  (add-hook 'eglot--managed-mode-hook (lambda () (flymake-mode -1)))
  (add-hook 'rust-mode-hook 'eglot-ensure)
  :custom
  (rustic-analyzer-command '("rustup" "run" "stable" "rust-analyzer")))

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
