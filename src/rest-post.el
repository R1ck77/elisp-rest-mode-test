(require 'rest-state)
(require 'rest-utils)

(defconst rest-post-buffer-name "*Post Details*")

(defun rest-post--bind-keys ()
  (local-set-key (kbd "q") 'rest-utils--close-buffer))

(defun rest-post--format-post (post-data)
  (format "%s" post-data))

(defun rest-post--read-formatted-post (id)
  (rest-post--format-post (rest-api--read-post id)))

(defun rest-post--show-buffer (id)
  (with-current-buffer (rest-utils--context-buffer-bottom rest-post-buffer-name)
      (insert (rest-post--read-formatted-post id))
      (rest-utils--force-read-only)
      (rest-post--bind-keys)))

(provide 'rest-post)


