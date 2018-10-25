(require 'rest-state)
(require 'rest-utils)

(defconst rest-posts--buffer-name "*Posts*")
(defconst rest-posts--id-property 'post-id)
(defconst rest-posts--post-body 'post-is-body)
(defconst rest-posts--body-property 'post-body)

(defun rest-posts--get-post-id (post)
  (cdr (assoc 'id post)))

(defun rest-posts--get-body (post)
  (cdr (assoc 'body post)))

(defun rest-posts--boldify (string)
  (rest-utils--propertize-text string 'font-lock-face 'bold))

(defun rest-posts--format-post (post get-user-f)
  (let* ((id (rest-posts--get-post-id post))
         (user-for-id (funcall get-user-f (cdr (assoc 'userId post))))
         (user-name (cdr (assoc 'name user-for-id))))
    (rest-posts--boldify 
     (format "* id:%d <%s> %s\n"
             id
             user-name
             (cdr (assoc 'title post))))))

(defun rest-posts--format-post-with-user (post)
  "Format the post representation using the caching version of the get-user function"
  (rest-posts--format-post post 'rest-state--get-user-with-id))

(defun rest-posts--prepare-post-for-insertion (post)
  "Format the post and add a text property with its ID"
  (let ((formatted-post (rest-posts--format-post-with-user post))
        (post-id (rest-posts--get-post-id post))
        (body (rest-posts--get-body post)))
    (rest-utils--propertize-text (rest-utils--propertize-text formatted-post
                                                              rest-posts--id-property
                                                              post-id)
                                 rest-posts--body-property
                                 body)))

;;; TODO/FIXME filter posts with nil users, remove the \n at the end of the list
(defun rest-posts--insert-posts ()
  "Insert *all* posts of the service in the page.

Pagination would be a nice idea, but the API dosen't support it"
  (save-excursion 
    (let* ((users '()))
      (mapcar (lambda (post-as-string)
                (insert post-as-string)
                (redisplay))
              (mapcar 'rest-posts--prepare-post-for-insertion (rest-api--read-posts))))))

(defun rest-posts--get-current-id ()
  (get-text-property (point) rest-posts--id-property))

(defun rest-posts--get-current-body ()
  (get-text-property (point) rest-posts--body-property))

(defun rest-posts--open-post ()
  (interactive)
  (message "RET The current post id is: %d" (rest-posts--get-current-id)))

(defun rest-posts--set-body (string)
  (rest-utils--propertize-text string 'rest-posts--post-body t))

(defun rest-posts--backtrack-to-header ()
  (while (and (rest-posts--is-body?)
              (forward-line -1))))

(defun rest-posts--expand-post ()
  (interactive)
  (let ((body (rest-posts--get-current-body)))
    (when body
      (let ((inhibit-read-only t))
        (save-excursion
          (with-silent-modifications
           (forward-line)
           (insert (rest-posts--set-body (concat body "\n")))))))))

(defun rest-posts--is-body? ()
  (get-text-property (point) 'rest-posts--post-body))

(defun rest-posts--collapse-post ()
  (interactive)
  (rest-posts--backtrack-to-header)
  (with-silent-modifications
    (save-excursion
      (forward-line)
      (let ((inhibit-read-only t))
        (while (rest-posts--is-body?)
          (let ((kill-start (point)))
            (forward-line)
            (delete-region kill-start (point))))))))

(defun rest-posts--is-next-line-body? ()
  (save-excursion
    (and (= (forward-line) 0)
         (rest-posts--is-body?))))

(defun rest-posts--toggle-post ()
  (interactive)
  (if (or (rest-posts--is-body?)
          (rest-posts--is-next-line-body?))
      (rest-posts--collapse-post)
    (rest-posts--expand-post)))

(defun re-bind-enter ()
  (local-set-key (kbd "RET") 'rest-posts--open-post)
  (local-set-key (kbd "TAB") 'rest-posts--toggle-post))

(defun rest-posts--wipe-old-buffer ()
  (let ((old-buffer (get-buffer rest-posts--buffer-name)))
    (when old-buffer
      (kill-buffer old-buffer))))

(defun rest-posts--show-buffer ()
  (rest-posts--wipe-old-buffer)
  (switch-to-buffer rest-posts--buffer-name)
  (font-lock-mode)
  (rest-posts--insert-posts)  ;;; TODO/FIXME insert an error message if posts can't be read
  (rest-utils--force-read-only)
  (re-bind-enter))

(provide 'rest-posts)
