(require 'package)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
  (package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("946e871c780b159c4bb9f580537e5d2f7dba1411143194447604ecbaf01bd90c" "73a13a70fd111a6cd47f3d4be2260b1e4b717dbf635a9caee6442c949fad41cd" "962dacd99e5a99801ca7257f25be7be0cebc333ad07be97efd6ff59755e6148f" default)))
 '(package-selected-packages
   (quote
    (dumb-jump imenu-anywhere evil-leader neotree autopair flycheck git-gutter evil-search-highlight-persist powerline fiplr flymake-php ctags quickrun auto-complete-exuberant-ctags auto-complete web-mode relative-line-numbers evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'evil)
    (evil-mode 1)

(autoload 'php-mode "php-mode" "Major mode for editing php code." t)
    (add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
    (add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))

(add-hook 'php-mode-hook 'my-php-mode-stuff)

(defun my-php-mode-stuff ()
  (local-set-key (kbd "<f1>") 'my-php-symbol-lookup))


(defun my-php-symbol-lookup ()
  (interactive)
  (let ((symbol (symbol-at-point)))
    (if (not symbol)
        (message "No symbol at point.")

      (browse-url (concat "http://php.net/manual-lookup.php?pattern="
                          (symbol-name symbol))))))

;; Relative number
(global-relative-line-numbers-mode
  (setq relative-line-numbers-current-line "->")
)

;; Fuzzy finder
(setq fiplr-ignored-globs '((directories (".git" ".svn"))
    (files ("*.jpg" "*.png" "*.zip" "*~"))))
    (global-set-key (kbd "C-x C-f") 'fiplr-find-file)

;; Powerline
(require 'airline-themes)
    (load-theme 'airline-badwolf)
    (setq powerline-utf-8-separator-left        #xe0b0
      powerline-utf-8-separator-right       #xe0b2
      airline-utf-glyph-separator-left      #xe0b0
      airline-utf-glyph-separator-right     #xe0b2
      airline-utf-glyph-subseparator-left   #xe0b1
      airline-utf-glyph-subseparator-right  #xe0b3
      airline-utf-glyph-branch              #xe0a0
      airline-utf-glyph-readonly            #xe0a2
      airline-utf-glyph-linenumber          #xe0a1)

;; Hightlight search
(require 'evil-search-highlight-persist)
    (global-evil-search-highlight-persist t)

;; Autocomplete
(ac-config-default)

;; Gitgutter
(global-git-gutter-mode +1)
    (set-face-foreground 'git-gutter:modified "orange")
    (set-face-foreground 'git-gutter:added "green")
    (set-face-foreground 'git-gutter:deleted "red")

;; Autopair
(require 'autopair)
(autopair-global-mode) ;; enable autopair in all buffers

;; Neotree
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
(define-minor-mode neotree-evil
  "Use NERDTree bindings on neotree."
  :lighter " NT"
  :keymap (progn
            (evil-make-overriding-map neotree-mode-map 'normal t)
            (evil-define-key 'normal neotree-mode-map
              "C" 'neotree-change-root
              "U" 'neotree-select-up-node
              "r" 'neotree-refresh
              "o" 'neotree-enter
              (kbd "<return>") 'neotree-enter
              "i" 'neotree-enter-horizontal-split
              "s" 'neotree-enter-vertical-split
              "n" 'evil-search-next
              "N" 'evil-search-previous
              "ma" 'neotree-create-node
              "mc" 'neotree-copy-file
              "md" 'neotree-delete-node
              "mm" 'neotree-rename-node
              "gg" 'evil-goto-first-line
              "gi" (lambda ()
                     (interactive)
                     (if (string= pe/get-directory-tree-external-command
                                  nt/gitignore-files-cmd)
                         (progn (setq pe/get-directory-tree-external-command
                                      nt/all-files-cmd))
                       (progn (setq pe/get-directory-tree-external-command
                                    nt/gitignore-files-cmd)))
                     (nt/refresh))
              "I" (lambda ()
                    (interactive)
                    (if pe/omit-enabled
                        (progn (setq pe/directory-tree-function
                                     'pe/get-directory-tree-async)
                               (pe/toggle-omit nil))
                      (progn (setq pe/directory-tree-function
                                   'pe/get-directory-tree-external)
                             (pe/toggle-omit t)))))
            neotree-mode-map))

(setq neo-hidden-files-regexp "^\\.\\|~$\\|^#.*#$\\|^target$\\|^pom\\.*")

;; Evil-leader
(global-evil-leader-mode)
(evil-leader/set-key "1" 'neotree-toggle)

;; Go to definition
(global-set-key (kbd "C-[") 'dumb-jump-go)
(global-set-key (kbd "C-]") 'dumb-jump-quick-look)

;; PHPCS
(require 'flymake-phpcs)
(add-hook 'php-mode-hook 'flymake-phpcs-load)
