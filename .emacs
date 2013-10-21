; .emacs file 
; Bhaskar Mookerji
; 
; Started: Sunday, 3 October 2010
; Last revised: Sunday, 3 October 2010

;;; Configuring Emacs usage

;;; Useful programming 

; enable syntax highlighting and other formatting functions
(require 'font-lock) 
(setq-default fill-column 79)

;; LaTeX
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master)

;; Setup linenumbers 
;; This is called from ~/Library/Preferences/Aquamacs Emacs/Preferences.el
;;(defun linenumbers ()
;;  (interactive)
;;  (when (featurep 'aquamacs)
;    (linum-mode)))

(global-linum-mode 1)

;; Font and writeroom
;; (defun writeroom ()
;;  "Switches to a WriteRoom-like fullscreen style"
;;  (interactive)
;;  (when (featurep 'aquamacs)
;;    (color-theme-sanityinc-solarized-dark)
;;    (aquamacs-autoface-mode 0)
;;    (set-frame-font "-apple-monaco*-medium-r-normal--12-*-*-*-*-*-fontset-monaco12")
 ;;   (aquamacs-toggle-full-frame)))

; http://www-users.math.umd.edu/~halbert/dotemacs.html
;; Remove toolbar
(tool-bar-mode -1)
;; Make initial frame as tall as possible
(setq initial-frame-alist '((top . 1) (height . 63)))
(setq column-number-mode t)

;;;
;;; https://sites.google.com/site/steveyegge2/effective-emacs
; Item 1: Swap Caps-Lock and Control
;; Done in OS X

; Item 2: Invoke M-x without the Alt key
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

; Item 3: Prefer backward-kill-word over Backspace
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-h" 'delete-backward-char)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

; Item 4: Use incremental search for Navigation
(global-set-key "\C-x:"      'goto-line)

; Item 5: Use Temp Buffers
;; C-x b + name -> create buffer

; Item 6: Master the buffer and window commands

;; Ctrl-x 2:  split-window-vertically 
;; Ctrl-x 3:  split-window-horizontally 
;; Ctrl-x +:  balance-windows -- makes all visible windows approximately 
;;                            equal height.
;; Ctrl-x o:  other-window 
;; Ctrl-x 1:  delete-other-windows 
;; Ctrl-x Ctrl-b: list-buffers

; Item 7: Lose the UI
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
;; (if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;; (if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

; Item 8: Learn the most important help functions

; Item 9: Master Emacs's regular expressions
(defalias 'qrr 'query-replace-regexp)
(global-set-key "\M-^" 'query-replace-regexp)

; Item 10: Master the fine-grained text manipulation commands                  
(global-set-key [f5] 'call-last-kbd-macro)
;;;

;; Use ibuffer
(defalias 'list-buffers 'ibuffer)
(iswitchb-mode 1)

;; Org-mode 
;; The following lines are always needed.  Choose your own keys.
;; Any file that ends with .org will be opened in org-mode    
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
;(when
;    (load
;     (expand-file-name "~/.emacs.d/elpa/package.el"))
;  (package-initialize))


; for .cch/.ds DiscoveryEngine files 

(add-to-list 'auto-mode-alist '("[.]cch$" . c++-mode))
(add-to-list 'auto-mode-alist '("[.]ds$" . c++-mode))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )


(load-library "~/.emacs.d/color-theme.el")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
;     (color-theme-initialize)
     (color-theme-hober)))

(add-to-list 'load-path "~/.emacs.d/emacs-color-theme-solarized")
(if
    (equal 0 (string-match "^24" emacs-version))
    ;; it's emacs24, so use built-in theme
    (require 'solarized-dark-theme)
  ;; it's NOT emacs24, so use color-theme
  (progn
    (require 'color-theme)
;    (color-theme-initialize)
    (require 'color-theme-solarized)
    (color-theme-solarized-dark)))



(add-to-list 'load-path "/Users/mookerji/.emacs.d/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "/home/mookerji/.emacs.d/ac-dict")
(ac-config-default)


; Highlight the current line
(global-hl-line-mode 1)
; (setq-default c-basic-offset 4) (only for DE)
(setq c-basic-offset 2)
(setq default-tab-width 4)
(setq-default indent-tabs-mode nil)	

; When switching branches, this updates emacs version from disk.
(global-auto-revert-mode 1)

; toggle window split

(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

(define-key ctl-x-4-map "t" 'toggle-window-split)

; stuff:
; Automatic indentation -> cleanup-buffer, bound to C-c n
; fuzzy file search: PeepOpen and textmate.el

(require 'package)
(add-to-list 'package-archives 
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))
(package-initialize)

(setq load-path (cons "/usr/local/go/misc/emacs" load-path))
(require 'go-mode-load)

(add-to-list 'load-path "~/.emacs.d/haskell-mode/")
(require 'haskell-mode-autoloads)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

(add-hook 'java-mode-hook
          (lambda ()
            "Treat Java 1.5 @-style annotations as comments."
            (setq c-comment-start-regexp "(@|/(/|[*][*]?))")
            (modify-syntax-entry ?@ "< b" java-mode-syntax-table)))
(add-hook 'java-mode-hook (lambda () (setq c-basic-offset 2)))

; Set font:
; http://www.emacswiki.org/emacs/SetFonts
(when (eq system-type 'darwin)
  (set-face-attribute 'default nil :family "Inconsolata" :height 145)
;  (set-face-attribute 'default nil :height 165)
)

(add-to-list 'load-path "~/.emacs.d/clojure/")
(require 'clojure-mode)
(add-hook 'clojure-mode-hook 'paredit-mode)
(setq inferior-lisp-program "/usr/local/bin/lein repl")

(defun turn-on-paredit () (paredit-mode 1))
(add-hook 'clojure-mode-hook 'turn-on-paredit)
