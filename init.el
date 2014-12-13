(require 'package)

(require 'cask "~/.cask/cask.el")
(cask-initialize)

;; Theme
(require 'color-theme-sanityinc-tomorrow)
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

;; Blank buffer on launch
(setf inhibit-splash-screen t)

;; Get your vim back
(require 'evil)
(evil-mode 1)

;; Powerline
(require 'powerline)
(powerline-vim-theme)

;; Surround.vim
(require 'evil-surround)
(global-evil-surround-mode 1)

(global-evil-leader-mode)
(evil-leader/set-leader "\\")
(evil-leader/set-key
 "." 'find-tag
 "t" 'projectile-find-file)

;; Projectile
(projectile-global-mode)

;; Mutli Term
(require 'multi-term)
(setq multi-term-program "/bin/zsh")
