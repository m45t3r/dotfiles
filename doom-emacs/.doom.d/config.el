;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

;;; GENERAL

;; theme
(load-theme 'doom-spacegrey t)

;; increase memory threshold
(setq doom-gc-cons-threshold (eval-when-compile (* 100 1024 1024)))

;; modeline
(setq doom-modeline-major-mode-icon t)

;; disable confirmation message on exit
(setq confirm-kill-emacs nil)

;; set window title with "[project] filename"
(setq frame-title-format
      (setq icon-title-format
            '(""
              (:eval
               (format "[%s] " (projectile-project-name)))
              "%b")))

;; font
(setq doom-font (font-spec :family "Hack" :size 14)
      doom-big-font-increment 4
      doom-unicode-font (font-spec :family "DejaVu Sans"))

(add-hook! 'after-make-frame-functions
  (set-fontset-font t 'unicode (font-spec :family "Font Awesome 5 Free") nil 'append)
  (set-fontset-font t 'unicode (font-spec :family "Font Awesome 5 Brands") nil 'append))

;; set localleader the same as Spacemacs
(setq doom-localleader-key ",")

;; enable minibuffer to work correctly in evil mode
(setq evil-collection-setup-minibuffer t)

;; general mappings
(map!
 ; move betweeen windows faster in normal mode
 :m "C-h" #'evil-window-left
 :m "C-j" #'evil-window-down
 :m "C-k" #'evil-window-up
 :m "C-l" #'evil-window-right
 ; move windows faster in normal mode
 :m "C-S-h" #'+evil/window-move-left
 :m "C-S-j" #'+evil/window-move-down
 :m "C-S-k" #'+evil/window-move-up
 :m "C-S-l" #'+evil/window-move-right
 ; move between characters in insert mode
 :i "C-h" #'backward-char
 :i "C-j" #'next-line
 :i "C-k" #'previous-line
 :i "C-l" #'forward-char
 ; misc
 :n "-" #'dired-jump
 :n "0" #'+treemacs/toggle
 :n "U" #'undo-tree-visualize
 (:leader
   (:prefix "t"
     :desc "Text zoom"
     "z" #'doom-text-zoom-hydra/body)))

;; which-key
(setq which-key-idle-delay 0.4)

;;; MODULES

;; company
(set-company-backend! :derived 'prog-mode
  #'company-files
  #'company-keywords)
(set-company-backend! :derived 'text-mode
  #'company-files)

(add-hook! company-mode
  (map!
   (:map company-active-map
     "TAB" #'company-select-next
     [tab] #'company-select-next
     [backtab] #'company-select-previous)))

(setq company-selection-wrap-around t)

;; dtrt-indent
(after! dtrt-indent
  (add-hook! prog-mode #'dtrt-indent-adapt))

;; projectile
(add-hook! projectile-mode
  (map!
   (:leader
     (:map projectile-mode-map
       (:prefix ("p" . "project")
         :desc "Toggle between implementation and test"
         "a" #'projectile-toggle-between-implementation-and-test
         :desc "Replace literal"
         "R" #'projectile-replace
         :desc "Replace using regexp"
         "X" #'projectile-replace-regexp)))))

;; rainbow
(add-hook! prog-mode #'rainbow-mode) ; Colorize hex color strings

;; whitespace
(setq whitespace-line-column 80 ; Highlight lines longer than 80 chars
      whitespace-style '(face lines-tail))

(add-hook! prog-mode #'whitespace-mode)

;;; LANGUAGES

;; clojure
(add-hook! clojure-mode
  (setq cljr-warn-on-eval nil
        cljr-eagerly-build-asts-on-startup nil)
  (map!
   (:map clojure-mode-map
     (:n "R" #'hydra-cljr-help-menu/body)
     (:localleader
       ("a" #'clojure-align)
       (:prefix ("e" . "eval")
         "b" #'cider-load-buffer
         "f" #'cider-eval-sexp-at-point
         "n" #'cider-eval-ns-form
         "c" #'cider-read-and-eval-defun-at-point
         "C" #'user/cider-read-eval-and-call-defun-at-point)
       (:prefix ("n" . "namespace")
         "r" #'cider-ns-refresh
         "R" #'cider-ns-reload)
       (:prefix ("t" . "test")
         "c" #'cider-test-clear-highlights
         "f" #'cider-test-rerun-failed-tests
         "n" #'cider-test-run-ns-tests
         "p" #'cider-test-run-project-tests
         "r" #'cider-test-show-report
         "t" #'cider-test-run-test
         "l" #'cider-test-run-loaded-tests
         "N" #'user/cider-eval-and-run-ns-tests
         "T" #'user/cider-eval-and-run-test)
       (:prefix ("r" . "repl")
         "'" #'cider-connect
         "\"" #'cider-connect-cljs)))))

;; elisp
(add-hook! emacs-lisp-mode
  (map!
   (:map emacs-lisp-mode-map
     (:localleader
       "e" nil ; Unmap macrostep-expand
       "x" #'macrostep-expand
       :desc "REPL"
       "r" #'+emacs-lisp/open-repl
       (:prefix ("e" . "eval")
         "b" #'eval-buffer
         "d" #'eval-defun
         "r" #'eval-region)))))

;; eshell
(add-hook! eshell-mode
  (setenv "TERM" "xterm-256color")
  (add-to-list 'eshell-preoutput-filter-functions #'xterm-color-filter)
  (setq eshell-output-filter-functions (remove #'eshell-handle-ansi-color
                                          eshell-output-filter-functions)))

(add-hook! 'eshell-before-prompt-hook
  (setq xterm-color-preserve-properties t))

;; markdown
(add-hook! markdown-mode
  (custom-set-variables
   '(markdown-command "pandoc"))
  (map!
   (:map markdown-mode-map
     (:localleader
       ("f" #'flymd-flyit)))))

;;; CUSTOM PACKAGES

;; lispyville
(def-package! lispyville
  :hook ((common-lisp-mode . lispyville-mode)
         (emacs-lisp-mode . lispyville-mode)
         (scheme-mode . lispyville-mode)
         (racket-mode . lispyville-mode)
         (hy-mode . lispyville-mode)
         (lfe-mode . lispyville-mode)
         (clojure-mode . lispyville-mode))
  :when (display-graphic-p) ;; lispyville breaks terminal Emacs
  :config
  (lispyville-set-key-theme
   `(additional
     additional-insert
     (additional-movement normal visual motion)
     (additional-wrap normal insert)
     c-w
     (commentary normal visual)
     (escape insert emacs)
     (operators normal)
     prettify
     slurp/barf-cp)))

;; uuidgen-el
(def-package! uuidgen
  :config
  (map!
   (:leader
     (:prefix ("i" . "insert")
       :desc "Insert UUIDv4"
       "u" #'uuidgen))))

;;; MISC

;; load local configuration file if exists
(load! "local.el" "~/.doom.d" t)
