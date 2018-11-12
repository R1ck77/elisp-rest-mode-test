(require 'rest)
(require 'demo-api)
(require 'demo-state)
(require 'demo-post)
(require 'demo-author)

(defconst demo-posts--buffer-name "*Posts*")
(defconst demo-posts--id-property 'post-id) ;;; this one could be removed

(defun demo-posts--get-post-id (post)
  (cdr (assoc 'id post)))

(defun demo-posts--get-body (post)
  (cdr (assoc 'body post)))

(defun demo-posts--show-missing-user ()
  " <NOT FOUND> ")

(defun demo-posts--show-valid-user (user-data)
  (let ((user-name (alist-get 'name user-data)))
    (rest-text-bold (number-to-string id))
    (concat " <"
            (rest-open-propertize (rest-text-yellow (substring user-name))
                                  (lexical-let ((user-data user-data))
                                    (lambda ()
                                      (demo-author-show-author (alist-get 'id user-data)))))
            "> ")))

(defun demo-posts--show-user-name (user-data)
  (if user-data
      (demo-posts--show-valid-user user-data)
    (demo-posts--show-missing-user)))

(defun demo-posts--format-post (post get-user-f)
  (let* ((id (demo-posts--get-post-id post))
         (user-for-id (funcall get-user-f (cdr (assoc 'userId post))))
         (title (cdr (assoc 'title post))))
    (concat "id:"
            (demo-posts--show-user-name user-for-id)
            title "\n")))

(defun demo-posts--format-post-with-user (post)
  "Format the post representation using the caching version of the get-user function"
  (seq-map (lambda (x) (concat x
                    (demo-posts--format-post post 'demo-state-get-user-with-id)))
       (list (rest-text-bold "+ ")
             (rest-text-bold "- "))))

(defun demo-posts--prepare-post-for-insertion (post)
  "Format the post and add a text property with its ID"
  (let ((formatted-post-pair (demo-posts--format-post-with-user post))
        (post-id (demo-posts--get-post-id post)))
    (seq-map (lambda (formatted-post)
           (rest-text-propertize-text formatted-post demo-posts--id-property post-id))
         formatted-post-pair)))

(defun demo-posts--get-body-for-post ()
  (rest-text-grey
   (demo-posts--get-body
    (demo-state-get-post-with-id
     (get-text-property (point) demo-posts--id-property)))))

(defun demo-posts--get-current-id ()
  (get-text-property (point) demo-posts--id-property))

;;; TODO/FIXME just a test, obviously: I can do fancier things with this
(defun demo-posts--add-expand-property (formatted-post formatted-post-expanded )
  (rest-expand-convert-to-expandable-text formatted-post
                                          'demo-posts--get-body-for-post
                                          formatted-post-expanded)) 

(defun demo-posts--add-open-property (formatted-post-pair)
  (seq-map (lambda (formatted-post)
         (rest-open-propertize formatted-post
                                        (lambda ()
                                          (demo-post-show-buffer (demo-posts--get-current-id)))))
       formatted-post-pair))

(defun demo-posts--insert-text-with-feedback (text)
  (insert text)
  (redisplay))

(defun demo-posts--convert-post-data-to-interactive-text (post-data)
  (demo-posts--insert-text-with-feedback
   (apply 'demo-posts--add-expand-property (demo-posts--add-open-property
     (demo-posts--prepare-post-for-insertion post-data)))))

(defun demo-posts--insert-posts ()
  "Insert *all* posts of the service in the page.

Pagination would be a nice idea, but the API dosen't support it"
  (save-excursion
    (mapcar 'demo-posts--convert-post-data-to-interactive-text (demo-api-read-posts))))

(defun demo-posts-show-buffer ()
  (rest-list-show demo-posts--buffer-name 'demo-posts--insert-posts 'demo-state-init))

(provide 'demo-posts)
