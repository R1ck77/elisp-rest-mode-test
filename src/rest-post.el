(require 'rest-state)
(require 'rest-detail)
(require 'rest-open)
(require 'rest-author)
(require 'rest-fmt)

(defconst rest-post-buffer-name "*Post Details*")

(defconst rest-post--column-size 8)

(defconst rest-post--title-formatter (rest-fmt-generate-plain-formatter "title" rest-post--column-size))

(defconst rest-post--user-formatter (rest-fmt-generate-simple-clickable-formatter "author"
                                                                           (lambda (field-content)
                                                                             (substring
                                                                              (rest-post--username-from-user-id (cdr field-content))))
                                                                           rest-post--column-size
                                                                           (lambda (field-content)
                                                                             (rest-author-show-author (cdr field-content)))))

(defconst rest-post--body-formatter (rest-fmt-generate-body-formatter))

(defconst rest-post--template (list (cons 'title rest-post--title-formatter)
                                      (cons 'userId rest-post--user-formatter)
                                      (cons 'body rest-post--body-formatter)))

(defun rest-post--username-from-user-id (user-id)
  (cdr (assoc 'name (rest-state-get-user-with-id user-id))))

(defun rest-post--read-formatted-post (id)
  (rest-detail-format-data (rest-state-get-post-with-id id)
                           rest-post--template))

(defun rest-post-show-buffer (id)
  (rest-detail-show rest-post-buffer-name
                    (rest-post--read-formatted-post id)))

(provide 'rest-post)
