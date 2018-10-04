;;; -*- mode: emacs-lisp; coding: iso-2022-jp -*-;;;

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
(define-key global-map "\C-cb" 'helm-mini)
(define-key global-map "\C-cc" 'compile)
(define-key global-map "\C-cd" 'calendar);
;(define-key global-map "\C-ce" 'eshell)
;(define-key global-map "\C-cf" 'elisp-info-describe-function)
(define-key global-map "\C-cg" 'grep)
(define-key global-map "\C-cG" 'grep-find)
(define-key global-map "\C-ch" 'help-command)
;(define-key global-map "\C-ci" 'liece)
(define-key global-map "\C-cj" 'helm-show-kill-ring)
(define-key global-map "\C-ck" 'kill-this-buffer)
;(define-key global-map "\C-clf" 'elisp-info-describe-function)
;(define-key global-map "\C-cll" 'lookup)
;(define-key global-map "\C-cln" 'namazu)
;(define-key global-map "\C-clp" 'lookup-pattern)
;(define-key global-map "\C-clr" 'lookup-region)
;(define-key global-map "\C-clv" 'elisp-info-describe-variable)
;(define-key global-map "\C-clw" 'lookup-word)
(define-key global-map "\C-cm" 'wl)
(define-key global-map "\C-cn" 'navi2ch)
(define-key global-map "\C-co" 'occur)
(define-key global-map "\C-cq" 'query-replace-regexp)
;(define-key global-map "\C-cr" 'man);
(define-key global-map "\C-cs" 'FUJII-scratch)
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
(define-key global-map "\C-cvm" 'magit-status)
(define-key global-map "\C-cw" 'eww)
;(define-key global-map "\C-cx" ')
(define-key global-map "\C-cy" 'cymemo)
(define-key global-map "\C-cz" 'shell)

;; C-h is backspace, C-S-h is help-command
(load "term/bobcat")
(when (fboundp 'terminal-init-bobcat)
  (terminal-init-bobcat))

;; face
(unless window-system
  (setq frame-background-mode 'dark))
(set-face-foreground 'font-lock-comment-face "pink")

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
(package-initialize)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)

(let ((packages '(cp5022x
		  editorconfig
		  helm
		  japanese-holidays
		  markdown-mode
		  wanderlust)))
  (when (memq nil (mapcar 'package-installed-p packages))
    (package-refresh-contents)
    (mapcar 'package-install packages)))

;; misc function

(defun FUJII-scratch ()
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
(defun dired-custom-execute-file (&optional arg)
  (interactive "P")
  (mapcar (lambda (file)
	    (let ((prog (cond
			 ((eq system-type 'windows-nt) "explorer")
			 ((eq system-type 'cygwin) "cygstart")
			 (t "xdg-open"))))
	      (call-process prog
			    nil nil nil (convert-standard-filename file))))
	  (dired-get-marked-files nil arg)))

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
(add-hook 'diff-mode-hook
	  (lambda ()
	    (define-key diff-mode-map "\e" nil)))

;; eldoc-mode
(add-hook 'emacs-lisp-mode-hook  'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode 'turn-on-eldoc-mode)


;; show-paren-mode
(eval-after-load "paren"
  '(set-face-background 'show-paren-match-face "navy"))
(make-variable-buffer-local 'show-paren-mode)

(dolist (hook
	 '(lisp-mode-hook
	   emacs-lisp-mode-hook ;lisp-interaction-mode-hook
	   scheme-mode-hook
	   inferior-scheme-mode-hook
	   ;guile-scheme-mode-hook
	   ))
  (add-hook hook
	    (lambda () (show-paren-mode 1))))


;; calendar
(when (< emacs-major-version 25)
  (add-hook 'calendar-load-hook
	    (lambda ()
	      (when (require 'japanese-holidays nil t)
		(setq calendar-holidays
		      (append japanese-holidays local-holidays other-holidays)
		      mark-holidays-in-calendar t))))
  (add-hook 'today-visible-calendar-hook 'calendar-mark-today))
(when (>= emacs-major-version 25)
  (add-hook 'calendar-load-hook
	    (lambda ()
	      (when (require 'japanese-holidays nil t)
		(setq calendar-holidays japanese-holidays)
		(setq calendar-mark-holidays-flag t))
	      (add-hook 'calendar-today-visible-hook 'calendar-mark-today))))

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

;; woman
(setq woman-use-own-frame nil)
(setq woman-use-topic-at-point t)

;; recentf
(setq recentf-max-saved-items 500)
(setq recentf-auto-cleanup 60)
(recentf-mode 1)

;; editorconfig
(editorconfig-mode 1)

;; helm
(require 'helm-files nil t)
(require 'helm-config nil t)

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

;; UTF-8
(when (fboundp 'utf-translate-cjk-set-unicode-range)
  (utf-translate-cjk-set-unicode-range
   '((?\x2e80 . ?\xd7a3)
     (?\xff00 . ?\xffef)
     (?\xa7 . ?\xa7)
     (?\xb0 . ?\xb1)
     (?\xb4 . ?\xb4)
     (?\xb6 . ?\xb6)
     (?\xd7 . ?\xd7)
     (?\xf7 . ?\xf7)
     (?\x370 . ?\x3ff)
     (?\x400 . ?\x4ff)
     (?\x2000 . ?\x206f)
     (?\x2103 . ?\x2103)
     (?\x212b . ?\x212b)
     (?\x2190 . ?\x21ff)
     (?\x2200 . ?\x22ff)
     (?\x2300 . ?\x23ff)
     (?\x2500 . ?\x257f)
     (?\x25a0 . ?\x25ff)
     (?\x2600 . ?\x26ff))))

(cond
 ((fboundp 'w32-ime-initialize)
  (setq default-input-method "W32-IME")
  (setq-default w32-ime-mode-line-state-indicator "[--]")
  (setq w32-ime-mode-line-state-indicator-list '("[--]" "[$B$"(B]" "[--]"))
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
