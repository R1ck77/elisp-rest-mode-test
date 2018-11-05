(require 'rest-state)
(require 'rest-detail)
(require 'rest-open)
(require 'rest-author)

(defconst rest-post-buffer-name "*Post Details*")

(defconst rest-post--column-size 8)

(defconst rest-detail--title-formatter (rest-detail-generate-plain-formatter "title" rest-post--column-size))

(defconst rest-detail--user-formatter (rest-detail-generate-clickable-formatter "author"
                                                                                (lambda (field-content)
                                                                                  (substring
                                                                                   (rest-post--username-from-user-id (cdr field-content))))
                                                                                rest-post--column-size
                                                                                (lambda (field-content)
                                                                                  (rest-author-show-author (cdr field-content)))))


(defconst rest-detail--body-formatter (rest-detail-generate-body-formatter))

(defconst rest-detail--template (list (cons 'title rest-detail--title-formatter)
                                      (cons 'userId rest-detail--user-formatter)
                                      (cons 'body rest-detail--body-formatter)))

(defun rest-post--username-from-user-id (user-id)
  (cdr (assoc 'name (rest-state-get-user-with-id user-id))))

(defun rest-post--read-formatted-post (id)
  (rest-detail-format-data (rest-state-get-post-with-id id)
                           rest-detail--template))

(defun rest-post-show-buffer (id)
  (rest-detail-show rest-post-buffer-name
                    (rest-post--read-formatted-post id)))

(provide 'rest-post)
