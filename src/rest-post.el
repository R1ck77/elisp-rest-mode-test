(require 'rest-state)
(require 'rest-utils)

(defconst rest-post-buffer-name "*Post Details*")

(defun rest-post--show-buffer (id)
  (rest-utils--wipe-buffer-if-present rest-post-buffer-name)
  (let ((buffer (get-buffer-create rest-post-buffer-name)))    
    (display-buffer-in-side-window buffer nil)
    (with-current-buffer buffer      
      (insert (format "RET The current post id is: %d" id)))))

(provide 'rest-post)


