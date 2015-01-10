(require 'cask "~/.cask/cask.el")
(cask-initialize)

(require 'evil)
(require 'birdseye)
(require 'color-theme-sanityinc-tomorrow)
(require 'evil-surround)
(require 'powerline)
(require 'powerline-evil)
(require 'multi-term)
(require 'neotree)
(require 'paredit)
(require 'evil-paredit)
(require 'clojure-mode)
(require 'cider)

;; Theme
(custom-set-faces
 '(flycheck-info        ((t (:background "#444" :underline t :style wave))))
 '(flycheck-warning     ((t (:background "#7A6200" :inverse t :underline t))))
 '(flycheck-error       ((t (:background "#800000" :inverse t :underline t :bold t))))
 '(cider-error-highlight-face  ((t (:inverse-video t
						   :background "#800000"
						   :underline t
						   :bold t))))
  '(magit-item-highlight ((t nil))))

(load-theme 'sanityinc-tomorrow-eighties t)

;; Hide menu bar
(menu-bar-mode -1)

;; Clean up line numbers
(setq linum-format "%3d ")

;; Blank buffer on launch
(setf inhibit-splash-screen t)

;; Get your vim back
(evil-mode 1)

;; Page Up
(evil-define-key 'normal global-map
  (kbd "C-u") 'evil-scroll-page-up)

;; Evil state in cider repl
(evil-set-initial-state 'cider-mode 'normal)

;;;;;;;;;;;;;;;;;
;; jk binding
;;;;;;;;;;;;;;;;;

; In this section we implement code that will allow us
; to get into evil-normal mode using "jk" in insert mode.
;
(evil-define-command zoo/jk-to-normal-mode ()
  "Allows to get into 'normal' mode using 'jk'."
  :repeat change
  (let ((modified (buffer-modified-p)))
    (insert "j")
    (let ((evt (read-event (format "Insert %c to exit insert state" ?k)
			   nil 0.5)))
      (cond
       ((null evt)
	(message ""))
       ((and (integerp evt)
	     (char-equal evt ?k))
	;; remove the j character
	(delete-char -1)
	(set-buffer-modified-p modified)
	(push 'escape unread-command-events))
       (t ; otherwise
	(setq unread-command-events (append unread-command-events
					    (list evt))))))))

;;;;;;;;;;;;;;
;; Insert Mode
;;;;;;;;;;;;;;
;;
;; Adding the binding for the j character, then
;; the k is handled on the function
(define-key evil-insert-state-map "j" #'zoo/jk-to-normal-mode)

;; Powerline
(powerline-evil-vim-color-theme)

;; Surround
(global-evil-surround-mode 1)

(global-evil-leader-mode)
(evil-leader/set-leader "\\")
(evil-leader/set-key
 "." 'find-tag
 "f" 'projectile-find-file
 "p" 'projectile-switch-project
 "g" 'magit-status
 "n" 'neotree-toggle
 "m" 'multi-term-dedicated-open)

;; Neotree
;;(setq projectile-switch-project-action 'neotree-projectile-action)

;; Projectile
(projectile-global-mode)

;; Mutli Term
(setq multi-term-program "/bin/zsh")

;; Auto-save to temp directory
(setq backup-directory-alist
  `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
  `((".*" ,temporary-file-directory t)))

(be/util-eval-on-mode clojure-mode
  (paredit-mode)
  (rainbow-delimiters-mode))

;; Clear whitespace on save
(add-hook 'before-save-hook 'whitespace-cleanup)

;; Clojure

(defun clj-save-run-tests ()
  (interactive)
  (save-buffer)
  (cider-load-buffer (current-buffer))
  (cider-test-run-tests t))

(evil-define-key 'normal clojure-mode-map
  (kbd ",t") 'clj-save-run-tests)
