(defun rest-posts--format-post (post get-user-f)
  (let* ((id (cdr (assoc 'id post)))
         (user-for-id (funcall get-user-f (cdr (assoc 'userId post))))
         (user-name (cdr (assoc 'name user-for-id))))
    (format "* id:%d <%s> %s"
            id
            user-name
            (cdr (assoc 'title post)))))

(defun rest-posts--format-post-with-user (post)
  (rest-posts--format-post post 'rest-mode--get-user-with-id))

;;; TODO/FIXME too messy
(defun rest-posts--insert-posts ()
  (save-excursion 
    (let* ((users '()))
      (mapcar (lambda (post-as-string)
                (insert post-as-string)
                (insert "\n")
                (redisplay))
              (mapcar 'rest-posts--format-post-with-user (rest-read-posts))))))


(defun print-window-size ()
  (message "The window range is: %d-%d" (window-start) (window-end)))

(defun add-update-hook ()
  (add-hook 'post-command-hook 'print-window-size t t))

(provide 'rest--posts)
