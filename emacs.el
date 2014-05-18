;;; -*- mode: emacs-lisp; coding: iso-2022-jp -*-;;;

;; user
(setq user-mail-address "fujii.hironori@gmail.com")
(setq user-full-name "Fujii Hironori")

;; coding-system
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
;(set-selection-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)

;; key bind
(define-key global-map "\C-o" 'toggle-input-method)

(define-key global-map "\C-ca" 'apropos)
;(define-key global-map "\C-cb" 'electric-buffer-list)
(define-key global-map "\C-cb" 'helm-mini)
(define-key global-map "\C-cc" 'compile)
(define-key global-map "\C-cd" 'calendar);
(define-key global-map "\C-ce" 'eshell)
(define-key global-map "\C-cf" 'elisp-info-describe-function)
(define-key global-map "\C-cg" 'grep)
(define-key global-map "\C-cG" 'grep-find)
(define-key global-map "\C-ch" 'help-command)
;(define-key global-map "\C-ci" 'liece)
;(define-key global-map "\C-cj" 'imenu);
(define-key global-map "\C-ck" 'kill-this-buffer)
(define-key global-map "\C-clf" 'elisp-info-describe-function)
(define-key global-map "\C-cll" 'lookup)
;(define-key global-map "\C-cln" 'namazu)
(define-key global-map "\C-clp" 'lookup-pattern)
(define-key global-map "\C-clr" 'lookup-region)
(define-key global-map "\C-clv" 'elisp-info-describe-variable)
(define-key global-map "\C-clw" 'lookup-word)
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
(define-key global-map "\C-cva" 'ahg-status)
(define-key global-map "\C-cvm" 'magit-status)
(define-key global-map "\C-cw" 'w3m)
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
(iswitchb-mode 1)

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
      (setq load-path (cons my-lisp-dir load-path))
      (normal-top-level-add-subdirs-to-load-path)))

;; env
;(setenv "PAGER" "cat")

;; package
(require 'package)
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)
; Wanderlust
(add-to-list 'package-archives
  '("e6h" . "http://www.e6h.org/packages/"))

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
	    (call-process (if (eq system-type 'windows-nt) "explorer" "xdg-open")
			  nil nil nil (convert-standard-filename file)))
	  (dired-get-marked-files nil arg)))

(add-hook 'dired-mode-hook (lambda () (define-key dired-mode-map "X" 'dired-custom-execute-file)))

;; electric-bufffer-list
(add-hook 'electric-buffer-menu-mode-hook 'forward-line)

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
(add-hook 'calendar-load-hook
	  (lambda ()
	    (when (require 'japanese-holidays nil t)
	      (setq calendar-holidays
		    (append japanese-holidays local-holidays other-holidays)
		    mark-holidays-in-calendar t))))
(add-hook 'today-visible-calendar-hook 'calendar-mark-weekend)
(add-hook 'today-invisible-calendar-hook 'calendar-mark-weekend)
(setq calendar-weekend '(0 6))
(add-hook 'today-visible-calendar-hook 'calendar-mark-today)

;; browse-url
(setq browse-url-generic-program "xdg-open")
(setq browse-url-browser-function
      (cond
       ((memq system-type '(windows-nt ms-dos cygwin)) 'browse-url-default-windows-browser)
       ((memq system-type '(darwin)) 'browse-url-default-macosx-browser)
       (t 'browse-url-generic)))

;; shell
(add-hook 'shell-mode-hook
	  (lambda ()
	    (process-kill-without-query 
	     (get-buffer-process (current-buffer)))))

;; woman
(setq woman-use-own-frame nil)
(setq woman-use-topic-at-point t)

;; auto-complete
(add-hook 'after-init-hook
	  (lambda ()
	    (when (require 'auto-complete-config nil t)
	      (ac-config-default)
	      (auto-complete-mode 1))))

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
;(load "egg/leim-list")
;(setq default-input-method "japanese-egg-anthy")
;(setq its-hira-enable-zenkaku-alphabet nil)
;(setq its-hira-period ". ")
;(setq its-hira-comma  ", ")
;(setq quail-japanese-use-double-n t)

;; vc
(setq vc-handled-backends '(RCS CVS SVN SCCS Bzr Hg Mtn Arch)) ; Remove Git

;; magit
(autoload 'magit-status "magit" nil t)
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
  (setq default-input-method "japanese-mozc")))

(when (eq system-type 'windows-nt)
  (setq w32-recognize-altgr nil))
