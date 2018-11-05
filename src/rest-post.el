(require 'rest-state)
(require 'rest-detail)
(require 'rest-open)

(defconst rest-post-buffer-name "*Post Details*")

(defconst rest-post--column-size 8)

(defconst rest-detail--template (list (cons 'title (rest-detail-generate-plain-formatter "title" rest-post--column-size))
                                      (cons 'userId (rest-detail-generate-clickable-formatter "author"
                                                                                              (lambda (field-content)
                                                                                                (substring (rest-post--username-from-user-id (cdr field-content))))
                                                                                              rest-post--column-size
                                                                                              (lambda () (print "SUCCESS!"))))
                                      (cons 'body (rest-detail-generate-body-formatter))))

(defun rest-post--username-from-user-id (user-id)
  (cdr (assoc 'name (rest-state-get-user-with-id user-id))))

(defun rest-post--read-formatted-post (id)
  (rest-detail-format-data (rest-state-get-post-with-id id)
                           rest-detail--template))

;;; TODO/FIXME wrong name for a public function
(defun rest-post--show-buffer (id)
  (rest-detail-show rest-post-buffer-name
                    (rest-post--read-formatted-post id)))

(provide 'rest-post)
