;; user
(setq user-mail-address "fujii.hironori@gmail.com")
(setq user-full-name "Fujii Hironori")

;; coding-system
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;; key bind
(define-key global-map "\C-o" 'toggle-input-method)

;(define-key global-map "\C-ca" 'apropos)
;(define-key global-map "\C-cb" 'electric-buffer-list)
(define-key global-map "\C-cc" 'compile)
(define-key global-map "\C-cd" 'calendar)
;(define-key global-map "\C-ce" 'eshell)
;(define-key global-map "\C-cf" 'elisp-info-describe-function)
(define-key global-map "\C-cg" 'grep)
(define-key global-map "\C-cG" 'grep-find)
(define-key global-map "\C-ch" 'help-command)
(define-key global-map "\C-ci" 'term/shell)
(define-key global-map "\C-cj" 'yank-from-kill-ring)
(define-key global-map "\C-ck" 'kill-this-buffer)
;(define-key global-map "\C-clf" 'elisp-info-describe-function)
;(define-key global-map "\C-cll" 'lookup)
;(define-key global-map "\C-cln" 'namazu)
;(define-key global-map "\C-clp" 'lookup-pattern)
;(define-key global-map "\C-clr" 'lookup-region)
;(define-key global-map "\C-clv" 'elisp-info-describe-variable)
;(define-key global-map "\C-clw" 'lookup-word)
(define-key global-map "\C-cm" 'man)
;(define-key global-map "\C-cn" 'navi2ch)
(define-key global-map "\C-co" 'occur)
(define-key global-map "\C-cq" 'query-replace-regexp)
(define-key global-map "\C-cr" 'recentf-open)
(define-key global-map "\C-cs" 'my-scratch)
(define-key global-map "\C-cte" 'toggle-debug-on-error)
(define-key global-map "\C-ctl" 'toggle-truncate-lines)
(define-key global-map "\C-cto" 'overwrite-mode)
(define-key global-map "\C-ctt" 'toggle-transient-mark-mode)
(define-key global-map "\C-ctp" 'show-paren-mode)
(define-key global-map "\C-ctq" 'toggle-debug-on-quit)
(define-key global-map "\C-ctv" 'view-mode)
;(define-key global-map "\C-cu" ')
;(define-key global-map "\C-cv" 'elisp-info-describe-variable)
;(define-key global-map "\C-cva" 'ahg-status)
;(define-key global-map "\C-cvm" 'magit-status)
(define-key global-map "\C-cw" 'eww)
;(define-key global-map "\C-cx" ')
(define-key global-map "\C-cy" 'cymemo)
(define-key global-map "\C-cz" 'shell)

;; C-h is backspace, C-S-h is help-command
(load "term/bobcat")
(when (fboundp 'terminal-init-bobcat)
  (terminal-init-bobcat))

;; face
(setq frame-background-mode 'dark)

(let ((class '((class color))))
  (custom-theme-set-faces
   'user
   `(default ((,class (:background "#242424" :foreground "#f6f3e8"))))))

;; misc
(setq make-backup-files nil)
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)
(setq cursor-in-non-selected-windows nil)
(setq truncate-partial-width-windows nil)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
;(partial-completion-mode t)
(setq focus-follows-mouse nil)
(setq custom-file "~/.emacs.d/custom.el")
(setq split-width-threshold nil)
(setq sentence-end-double-space nil)
(setq fill-column 79)

; Emacs does not exit promptly. The message "Saving clipboard to X clipboard manager..." is shown.
(setq x-select-enable-clipboard t)
(setq x-select-enable-clipboard-manager nil)

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;;
;(put 'downcase-region 'disabled nil)

;; load-path
(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
    (let* ((my-lisp-dir "~/opt/share/emacs/site-lisp")
	   (default-directory my-lisp-dir))
      (when (file-exists-p my-lisp-dir)
	(setq load-path (cons my-lisp-dir load-path))
	(normal-top-level-add-subdirs-to-load-path))))

;; env
;(setenv "PAGER" "cat")

;; package
(require 'package)
(when (< emacs-major-version 27)
  (package-initialize))
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)

(defun my-install-favorite-packages (&rest packages)
  (interactive (read (read-string "Packages to install: " "(japanese-holidays)")))
  (when (memq nil (mapcar 'package-installed-p packages))
    (package-refresh-contents)
    (mapcar 'package-install packages)))

;; misc function

(defun my-scratch ()
  "Switch to the buffer *scratch*."
  (interactive)
  (let ((default-major-mode 'lisp-interaction-mode)
	(default-directory "~/"))
    (switch-to-buffer "*scratch*")))

(defun kill-all-unmodified-buffers ()
  (interactive)
  (mapc (lambda (b)
	  (or (buffer-modified-p b)
	      (string= (substring (buffer-name b) 0 1) " ")
	      (kill-buffer b)))
	(buffer-list)))


;; dired
(defun dired-custom-execute-file (&optional arg file-list)
  (interactive (list current-prefix-arg (dired-get-marked-files t current-prefix-arg nil nil t)))
  (let ((prog (cond
	       ((eq system-type 'windows-nt) "explorer")
	       ((eq system-type 'cygwin) "cygstart")
	       (t "xdg-open"))))
    (dired-do-shell-command prog arg file-list)))

(add-hook 'dired-mode-hook (lambda () (define-key dired-mode-map "X" 'dired-custom-execute-file)))

;; compile
(setq compilation-window-height 15)
(setq compilation-read-command nil)

;;; indent settings for C
(require 'cc-mode)
(c-add-style "webkit"
	     '("stroustrup"
	       (indent-tabs-mode . nil)
	       (c-offsets-alist
		(innamespace . 0)
		(arglist-cont . +)
		(arglist-cont-nonempty . +))))
(c-add-style "vs2005-c++-smart"
            '("stroustrup"
              (tab-width . 4)
              (indent-tabs-mode . t)
              (c-label-minimum-indentation . 0)
              (c-offsets-alist
               (case-label . +))))

(when (require 'google-c-style nil t)
  (c-add-style "google" google-c-style))

(defvar local-cc-mode-style-alist
  '(("webkit" . "webkit")))

;(add-to-list 'c-default-style '(c-mode . "vs2005-c++-smart"))
;(add-to-list 'c-default-style '(c++-mode . "vs2005-c++-smart"))

(defun local-cc-mode-hook ()
  (when buffer-file-name
    (let ((case-fold-search t))
      (catch 'exit
	(mapcar (lambda (e)
		  (when (string-match (car e) buffer-file-name)
		    (c-set-style (cdr e))
		    (throw 'exit nil))) local-cc-mode-style-alist)))))

(add-hook 'c-mode-hook 'local-cc-mode-hook)
(add-hook 'c++-mode-hook 'local-cc-mode-hook)

;; diff-mode
(setq diff-font-lock-syntax nil)
(add-hook 'diff-mode-hook
	  (lambda ()
	    (define-key diff-mode-map "\e" nil)))

;; eldoc-mode
(add-hook 'emacs-lisp-mode-hook  'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode 'turn-on-eldoc-mode)


;; show-paren-mode
(show-paren-mode 1)

;; calendar
(add-hook 'calendar-load-hook
	  (lambda ()
	    (when (require 'japanese-holidays nil t)
	      (setq calendar-holidays japanese-holidays)
	      (setq calendar-mark-holidays-flag t))
	    (add-hook 'calendar-today-visible-hook 'calendar-mark-today)))

;; browse-url
(setq browse-url-generic-program "xdg-open")
(setq browse-url-browser-function
      (cond
       ((memq system-type '(windows-nt ms-dos cygwin)) 'browse-url-default-windows-browser)
       ((memq system-type '(darwin)) 'browse-url-default-macosx-browser)
       (t 'browse-url-generic)))


;; eww
(setq eww-search-prefix "https://duckduckgo.com/lite/?q=")

;; shr
(setq shr-use-colors nil)

;; midnight-mode
(midnight-mode t)

;; shell
(add-hook 'shell-mode-hook
	  (lambda ()
	    (local-set-key "\M-p" 'comint-previous-matching-input-from-input)
	    (local-set-key "\M-n" 'comint-next-matching-input-from-input)
	    (setq comint-input-ring-file-name "~/.zsh_history")
	    ;; For EXTENDED_HISTORY format
	    (setq comint-input-ring-separator "\n\\(: [0-9]+:[0-9]+;\\)?")
	    (comint-read-input-ring t)
	    (process-kill-without-query 
	     (get-buffer-process (current-buffer)))))

(setq comint-input-ring-size 10000)

;; term-mode https://www.emacswiki.org/emacs/AnsiTermHints
(require 'term)
(defun term/shell (program &optional new-buffer-name)
  "Start a terminal-emulator in a new buffer.

    With a prefix argument, it prompts the user for the shell
    executable.

    If there is already existing buffer with the same name, switch to
    that buffer, otherwise it creates new buffer.

    Like `shell', it loads `~/.emacs_SHELLNAME' if exists, or
    `~/.emacs.d/init_SHELLNAME.sh'.

    The shell file name (sans directories) is used to make a symbol
    name such as `explicit-bash-args'.  If that symbol is a variable,
    its value is used as a list of arguments when invoking the
    shell."
  (interactive (let ((default-prog (or explicit-shell-file-name
                                       (getenv "ESHELL")
                                       shell-file-name
                                       (getenv "SHELL")
                                       "/bin/sh")))
                 (list (if (or (null default-prog)
                               current-prefix-arg)
                           (read-from-minibuffer "Run program: " default-prog)
                         default-prog))))
  ;; Pick the name of the new buffer.
  (setq term-ansi-buffer-name
        (if new-buffer-name
            new-buffer-name
          (if term-ansi-buffer-base-name
              (if (eq term-ansi-buffer-base-name t)
                  (file-name-nondirectory program)
                term-ansi-buffer-base-name)
            "shell/term")))

  (setq term-ansi-buffer-name (concat "*" term-ansi-buffer-name "*"))

  ;; In order to have more than one term active at a time
  ;; I'd like to have the term names have the *term-ansi-term<?>* form,
  ;; for now they have the *term-ansi-term*<?> form but we'll see...
  (when current-prefix-arg
    (setq term-ansi-buffer-name 
          (generate-new-buffer-name term-ansi-buffer-name)))

  (let* ((name (file-name-nondirectory program))
         (startfile (concat "~/.emacs_" name))
         (xargs-name (intern-soft (concat "explicit-" name "-args"))))
    (unless (file-exists-p startfile)
      (setq startfile (concat user-emacs-directory "init_" name ".sh")))

    (setq term-ansi-buffer-name
          (apply 'term-ansi-make-term term-ansi-buffer-name program
                 (if (file-exists-p startfile) startfile)
                 (if (and xargs-name (boundp xargs-name))
                     ;; `term' does need readline support.
                     (remove "--noediting" (symbol-value xargs-name))
                   '("-i")))))

  (set-buffer term-ansi-buffer-name)
  (term-mode)
  ;(term-line-mode)                      ; (term-char-mode) if you want
  (term-char-mode)

  ;; I wanna have find-file on C-x C-f -mm
  ;; your mileage may definitely vary, maybe it's better to put this in your
  ;; .emacs ...

  (term-set-escape-char ?\C-x)

  (switch-to-buffer term-ansi-buffer-name))

;; woman
(setq woman-use-own-frame nil)
(setq woman-use-topic-at-point t)

;; recentf
(setq recentf-max-saved-items 500)
(setq recentf-auto-cleanup 60)
(recentf-mode 1)

;; editorconfig
(when (require 'editorconfig nil t)
  (editorconfig-mode 1))

;; fido
(fido-vertical-mode 1)

;; wl
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'wl-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'wl-user-agent
      'wl-user-agent-compose
      'wl-draft-send
      'wl-draft-kill
      'mail-send-hook))

;; info
;(setq Info-additional-directory-list
;      '("~/usr/info" "~/usr/share/info"))

;; egg
(setq its-hira-enable-zenkaku-alphabet nil)
;(setq its-hira-period ". ")
;(setq its-hira-comma  ", ")
(setq anthy-egg-use-utf8 t)

;; quail
(setq quail-japanese-use-double-n t)

;; Google Japanese IME
(when (memq system-type '(windows-nt cygwin))
  (defadvice mozc-session-execute-command (after ad-mozc-session-execute-command activate)
    (if (eq (ad-get-arg 0) 'CreateSession)
	(mozc-session-sendkey '(hiragana)))))

;; magit
(setq magit-last-seen-setup-instructions "1.4.0")

(defface magit-item-highlight
  '((((class color) (background light))
     :background "gray95")
    (((class color) (background dark))
     :background "gray7"))
  "Face for highlighting the current item."
  :group 'magit)

;; input method
(cond
 ((fboundp 'w32-ime-initialize)
  (setq default-input-method "W32-IME")
  (setq-default w32-ime-mode-line-state-indicator "[--]")
  (setq w32-ime-mode-line-state-indicator-list '("[--]" "[あ]" "[--]"))
  (w32-ime-initialize)

  (wrap-function-to-control-ime 'y-or-n-p nil nil)
  (wrap-function-to-control-ime 'yes-or-no-p nil nil)
  (wrap-function-to-control-ime 'universal-argument t nil)
  (wrap-function-to-control-ime 'read-string nil nil)
  (wrap-function-to-control-ime 'read-from-minibuffer nil nil)
  (wrap-function-to-control-ime 'read-key-sequence nil nil)
  (wrap-function-to-control-ime 'map-y-or-n-p nil nil)
  (wrap-function-to-control-ime 'read-passwd t t) ; don't work as we expect.
  )
 ((require 'mozc nil t)
  (setq default-input-method "japanese-mozc"))
 ((load "egg/leim-list" t)
  (setq default-input-method "japanese-egg-anthy"))
 ((require 'anthy nil t)
  (setq default-input-method "japanese-anthy")))

(when (eq window-system 'w32)
  (setq w32-recognize-altgr nil))

;; server
(setenv "EDITOR" "emacsclient")
(server-start)

;; treesit-auto
(when (require 'treesit-auto nil t)
  (global-treesit-auto-mode 1))
