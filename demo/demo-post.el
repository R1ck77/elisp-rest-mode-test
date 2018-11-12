(require 'rest)
(require 'demo-author)

(defconst demo-post-buffer-name "*Post Details*")

(defconst demo-post--column-size 8)

(defconst demo-post--title-formatter (rest-fmt-generate-plain-formatter "title" demo-post--column-size))

(defconst demo-post--user-formatter (rest-fmt-generate-simple-clickable-formatter "author"
                                                                           (lambda (field-content)
                                                                             (substring
                                                                              (demo-post--username-from-user-id (cdr field-content))))
                                                                           demo-post--column-size
                                                                           (lambda (field-content)
                                                                             (demo-author-show-author (cdr field-content)))))

(defconst demo-post--body-formatter (rest-fmt-generate-body-formatter))

(defconst demo-post--template (list (cons 'title demo-post--title-formatter)
                                      (cons 'userId demo-post--user-formatter)
                                      (cons 'body demo-post--body-formatter)))

(defun demo-post--username-from-user-id (user-id)
  (cdr (assoc 'name (demo-state-get-user-with-id user-id))))

(defun demo-post--read-formatted-post (id)
  (rest-detail-format-data (demo-state-get-post-with-id id)
                           demo-post--template))

(defun demo-post-show-buffer (id)
  (rest-detail-show demo-post-buffer-name
                    (demo-post--read-formatted-post id)))

(provide 'demo-post)
