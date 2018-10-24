(require 'rest-state)
(require 'rest-utils)

(defconst rest-posts--id-property 'post-id)

(defun rest-posts--get-post-id (post)
  (cdr (assoc 'id post)))

(defun rest-posts--format-post (post get-user-f)
  (let* ((id (rest-posts--get-post-id post))
         (user-for-id (funcall get-user-f (cdr (assoc 'userId post))))
         (user-name (cdr (assoc 'name user-for-id))))
    (format "* id:%d <%s> %s"
            id
            user-name
            (cdr (assoc 'title post)))))

(defun rest-posts--format-post-with-user (post)
  "Format the post representation using the caching version of the get-user function"
  (rest-posts--format-post post 'rest-state--get-user-with-id))

(defun rest-posts--prepare-post-for-insertion (post)
  "Format the post and add a text property with its ID"
  (let ((formatted-post (rest-posts--format-post-with-user post))
        (post-id (rest-posts--get-post-id post)))
    (put-text-property 0 (length formatted-post)
                       rest-posts--id-property post-id
                       formatted-post)
    formatted-post))

(defun rest-posts--insert-posts ()
  "Insert *all* posts of the service in the page.

Pagination would be a nice idea, but the API dosen't support it"
  (save-excursion 
    (let* ((users '()))
      (mapcar (lambda (post-as-string)
                (insert post-as-string)
                (insert "\n")
                (redisplay))
              (mapcar 'rest-posts--prepare-post-for-insertion (rest-api--read-posts))))))

(defun jump-to-post ()
  (interactive)
  (message "Show the post here!"))

(defun re-bind-enter ()
  (local-set-key (kbd "RET") 'jump-to-post))

(defun rest-posts--show-buffer ()
  (switch-to-buffer "*Posts*")
  (rest-posts--insert-posts)
  (rest-utils--force-read-only)
  (re-bind-enter))

(provide 'rest-posts)
