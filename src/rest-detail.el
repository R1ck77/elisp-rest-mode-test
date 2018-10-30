(require 'rest-utils)

(defun rest-detail--bind-keys ()
    (local-set-key (kbd "q") 'rest-utils--close-buffer))

(defun rest-detail-show (buffer-name post-content)
  (with-current-buffer (rest-utils--context-buffer-bottom buffer-name)
    (font-lock-mode)
    (insert post-content)
    (rest-utils--force-read-only)
    (rest-detail--bind-keys)))

(provide 'rest-detail)
