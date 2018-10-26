(require 'rest-state)
(require 'rest-utils)

(defconst rest-post-buffer-name "*Post Details*")

(defun rest-post--close-buffer ()
  (interactive)
  (let ((kill-buffer-query-functions nil))
    (kill-buffer)))

(defun rest-post--bind-keys ()
  (local-set-key (kbd "q") 'rest-post--close-buffer))

(defun rest-post--show-buffer (id)
  (rest-utils--wipe-buffer-if-present rest-post-buffer-name)
  (let ((buffer (get-buffer-create rest-post-buffer-name)))    
    (display-buffer-in-side-window buffer nil)
    (with-current-buffer buffer
      (insert (format "RET The current post id is: %d" id))
      (rest-utils--force-read-only)
      (rest-post--bind-keys))))

(provide 'rest-post)


