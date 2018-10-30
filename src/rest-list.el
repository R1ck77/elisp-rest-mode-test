(require 'rest-utils)

(defun rest-list--bind-keys ()
  (rest-open-bind-key)  
  (local-set-key (kbd "r") 'rest-posts--show-buffer) ;;; !!!
  (local-set-key (kbd "q") 'rest-utils--close-buffer)
  (local-set-key (kbd "TAB") 'rest-posts--toggle-post)) ;;; !!!!

(defun rest-list-show (buffer-name )
  (rest-utils--wipe-buffer-if-present buffer-name)
  (switch-to-buffer buffer-name)
  (font-lock-mode)
  (rest-posts--insert-posts)  ;;; TODO/FIXME insert an error message if posts can't be read
  (rest-utils--force-read-only)
  (rest-list--bind-keys))

(provide 'rest-list)
