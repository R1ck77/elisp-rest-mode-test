(require 'rest-state)
(require 'rest-utils)
(require 'rest-post)
(require 'rest-expand)
(require 'rest-open)

(defconst rest-posts--buffer-name "*Posts*")
(defconst rest-posts--id-property 'post-id) ;;; this one could be removed

(defun rest-posts--get-post-id (post)
  (cdr (assoc 'id post)))

(defun rest-posts--get-body (post)
  (cdr (assoc 'body post)))

(defun rest-posts--format-post (post get-user-f)
  (let* ((id (rest-posts--get-post-id post))
         (user-for-id (funcall get-user-f (cdr (assoc 'userId post))))
         (user-name (cdr (assoc 'name user-for-id)))
         (title (cdr (assoc 'title post))))
    (concat (rest-utils--bold "*")
            " id:"
            (rest-utils--bold (number-to-string id))
            " <"
            (rest-utils--yellow (substring user-name))
            "> "
            title "\n")))

(defun rest-posts--format-post-with-user (post)
  "Format the post representation using the caching version of the get-user function"
  (rest-posts--format-post post 'rest-state--get-user-with-id))

(defun rest-posts--prepare-post-for-insertion (post)
  "Format the post and add a text property with its ID"
  (let ((formatted-post (rest-posts--format-post-with-user post))
        (post-id (rest-posts--get-post-id post)))
    (rest-utils--propertize-text formatted-post
                                 rest-posts--id-property post-id)))

(defun rest-posts--get-body-for-post ()
  (rest-utils--grey
   (rest-posts--get-body
    (rest-state--get-post-with-id
     (get-text-property (point) rest-posts--id-property)))))

(defun rest-posts--get-current-id ()
  (get-text-property (point) rest-posts--id-property))

(defun rest-posts--SOMETHING (formatted-post)
  (rest-open-propertize formatted-post
                        (lambda ()
                          (rest-post--show-buffer (rest-posts--get-current-id)))))

(defun rest-posts--SOMETHING-ELSE (formatted-post)
  (rest-expand-insert-expandable-text formatted-post 'rest-posts--get-body-for-post)
  (redisplay))

;;; TODO/FIXME filter posts with nil users, remove the \n at the end of the list
;;; TODO/FIXME also this function is a mess. Extract, like… 4 functions…
(defun rest-posts--insert-posts ()
  "Insert *all* posts of the service in the page.

Pagination would be a nice idea, but the API dosen't support it"
  (save-excursion
    (mapcar 'rest-posts--SOMETHING-ELSE
            (mapcar 'rest-posts--SOMETHING
                    (mapcar 'rest-posts--prepare-post-for-insertion (rest-api--read-posts))))))

(defun rest-posts--toggle-post ()
  (interactive)
  (let ((inhibit-read-only t))
   (rest-expand-toggle-text)))

(defun rest-posts--bind-keys ()
  (rest-open-bind-key)  
  (local-set-key (kbd "r") 'rest-posts--show-buffer)
  (local-set-key (kbd "q") 'rest-utils--close-buffer)
  (local-set-key (kbd "TAB") 'rest-posts--toggle-post))

(defun rest-posts--wipe-old-buffer ()
  (rest-utils--wipe-buffer-if-present rest-posts--buffer-name))

(defun rest-posts--show-buffer ()
  (interactive)
  (rest-posts--wipe-old-buffer)
  (switch-to-buffer rest-posts--buffer-name)
  (font-lock-mode)
  (rest-posts--insert-posts)  ;;; TODO/FIXME insert an error message if posts can't be read
  (rest-utils--force-read-only)
  (rest-posts--bind-keys))

(provide 'rest-posts)
