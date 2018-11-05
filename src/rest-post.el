(require 'rest-state)
(require 'rest-detail)

(defconst rest-post-buffer-name "*Post Details*")

(defconst rest-post--column-size 8)

(defconst rest-detail--template (list (cons 'title (rest-detail-generate-plain-formatter "title" rest-post--column-size))
                                      (cons 'userId (rest-detail-generate-indirect-plain-formatter "author"
                                                                                                   (lambda (field-content)
                                                                                                     (rest-post--username-from-user-id (cdr field-content)))
                                                                                                   rest-post--column-size))
                                      (cons 'body (rest-detail-generate-body-formatter))))

(defun rest-post--username-from-user-id (user-id)
  (cdr (assoc 'name (rest-state-get-user-with-id user-id))))

(defun rest-post--format-field (title-value)
  (rest-detail-format-simple (car title-value)
                             (cadr title-value)
                             rest-post--column-size))

(defun rest-post--data-to-printable-lines (post-data)
  (nconc
   (seq-map 'rest-post--format-field (list (list "title" (cdr (assoc 'title post-data)))
                                           (list "author" (rest-post--username-from-user-id (cdr (assoc 'userId post-data))))))
   (list (concat "\n"
                 (cdr (assoc 'body post-data))))))

(defun rest-post--format-post (post-data)
  (rest-detail-format-data post-data rest-detail--template))

(defun rest-post--read-formatted-post (id)
  (rest-post--format-post (rest-state-get-post-with-id id)))

;;; TODO/FIXME wrong name for a public function
(defun rest-post--show-buffer (id)
  (rest-detail-show rest-post-buffer-name
                    (rest-post--read-formatted-post id)))

(provide 'rest-post)
