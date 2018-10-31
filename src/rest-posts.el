(require 'rest-state)
(require 'rest-utils)
(require 'rest-post)
(require 'rest-expand)
(require 'rest-open)
(require 'rest-list)

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

(defun rest-posts--add-expand-property (formatted-post)
  (rest-expand-convert-to-expandable-text formatted-post 'rest-posts--get-body-for-post))

(defun rest-posts--add-open-property (formatted-post)
  (rest-open-propertize formatted-post
                        (lambda ()
                          (rest-post--show-buffer (rest-posts--get-current-id)))))

(defun rest-posts--insert-text-with-feedback (text)
  (insert text)
  (redisplay))

(defun rest-posts--convert-post-data-to-interactive-text (post-data)
  (rest-posts--insert-text-with-feedback
   (rest-posts--add-expand-property
    (rest-posts--add-open-property
     (rest-posts--prepare-post-for-insertion post-data)))))

(defun rest-posts--insert-posts ()
  "Insert *all* posts of the service in the page.

Pagination would be a nice idea, but the API dosen't support it"
  (save-excursion
    (mapcar 'rest-posts--convert-post-data-to-interactive-text (rest-api--read-posts))))

(defun rest-posts-show-buffer ()
  (rest-list-show rest-posts--buffer-name 'rest-posts--insert-posts))

(provide 'rest-posts)
