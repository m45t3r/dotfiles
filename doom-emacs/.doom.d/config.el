;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;;; GENERAL

;; Theme
(require 'doom-themes)
(load-theme 'doom-spacegrey t)
(doom-themes-neotree-config)
(doom-themes-org-config)

;; Modeline
(setq doom-modeline-major-mode-icon t)

;; Disable confirmation message on exit
(setq confirm-kill-emacs nil)

;; Font
(setq doom-font (font-spec :family "Hack" :size 14)
      doom-big-font (font-spec :family "Hack" :size 18))

;; Set localleader the same as Spacemacs
(setq doom-localleader-key ",")

;; Move betweeen windows faster
(map! (:g
       "C-h" #'evil-window-left
       "C-j" #'evil-window-down
       "C-k" #'evil-window-up
       "C-l" #'evil-window-right))

;; Highlight lines longer than 80 chars
(setq whitespace-line-column 80
      whitespace-style '(face lines-tail))

(add-hook! prog-mode #'whitespace-mode)

;; Dired
(define-key evil-normal-state-map (kbd "-") #'dired-jump)

;; Neotree
(setq doom-neotree-file-icons t)
(define-key evil-normal-state-map (kbd "C-x t") #'neotree)

;; Which-key
(setq which-key-idle-delay 0.1)

;; Undo-tree
(setq undo-tree-auto-save-history t
      undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))

;; Make ESC to work as expected in minibuffers
(map!
 (:map minibuffer-local-map [escape] #'minibuffer-keyboard-quit)
 (:map minibuffer-local-ns-map [escape] #'minibuffer-keyboard-quit)
 (:map minibuffer-local-completion-map [escape] #'minibuffer-keyboard-quit)
 (:map minibuffer-local-must-match-map [escape] #'minibuffer-keyboard-quit)
 (:map minibuffer-local-isearch-map [escape] #'minibuffer-keyboard-quit)
 (:g [escape] #'keyboard-quit))

;;; AFTER MODULE

;; Ivy
(after! ivy
  (map!
   (:leader
     (:prefix ("/" . "search")
       :desc "Search thing at point in git project"
       "*" #'+misc/search-thing-at-point))))


;; Dtrt-indent
(after! dtrt-indent
  (add-hook! (prog-mode text-mode) #'dtrt-indent-adapt))

;;; HOOKS

;; Projectile
(add-hook! projectile-mode
  (map!
   (:leader
     (:map projectile-mode-map
       (:prefix ("p" . "project")
         :desc "Toggle between implementation and test"
         "a" #'projectile-toggle-between-implementation-and-test
         :desc "Replace using regexp"
         "e" #'projectile-replace-regexp)))))

;; Clojure
(add-hook! clojure-mode
  (map!
   (:localleader
     (:map clojure-mode-map
       (:prefix ("e" . "eval")
         "b" #'cider-eval-buffer
         "f" #'cider-eval-sexp-at-point))
     (evil-define-key 'normal clojure-mode-map "gd" #'cider-find-var))))

(add-hook! cider-repl-mode
  (map!
   (:localleader
     (:map cider-repl-mode-map
       ("c" #'cider-repl-clear-buffer
        "R" #'cider-restart
        "r" #'cider-ns-refresh
        "q" #'cider-quit)))))

;; Term
(add-hook! term-mode
  (evil-set-initial-state 'term-mode 'emacs))

;;; CUSTOM PACKAGES

;; Lispyvile
(def-package! lispyville
  :hook ((common-lisp-mode . lispyville-mode)
         (emacs-lisp-mode . lispyville-mode)
         (scheme-mode . lispyville-mode)
         (racket-mode . lispyville-mode)
         (hy-mode . lispyville-mode)
         (lfe-mode . lispyville-mode)
         (clojure-mode . lispyville-mode))
  :config
  (lispyville-set-key-theme
   '(additional
     additional-insert
     (additional-movement normal visual motion)
     (additional-wrap normal insert)
     c-w
     (commentary normal visual)
     (escape insert emacs)
     (operators normal)
     prettify
     slurp/barf-cp)))

;; Zoom-frm
(def-package! zoom-frm
  :config
  (map! (:g
         "C-=" #'zoom-frm-in
         "C--" #'zoom-frm-out
         "C-0" #'zoom-frm-unzoom))
  (global-set-key (vector (list #'control mouse-wheel-down-event)) #'zoom-frm-in)
  (global-set-key (vector (list #'control mouse-wheel-up-event)) #'zoom-frm-out))

;;; MISC

;; Load local configuration file if exists
(load! "local.el" "~/.doom.d" t)
