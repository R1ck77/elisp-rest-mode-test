(require 'rest-state)
(require 'rest-utils)
(require 'rest-detail)

(defconst rest-post-buffer-name "*Post Details*")

(defun rest-post--format-field (title-value)
  (concat (rest-utils--bold (car title-value))
          (elt title-value 1)))

(defun rest-post--username-from-user-id (user-id)
  (cdr (assoc 'name (rest-state--get-user-with-id user-id))))

(defun rest-post--data-to-printable-lines (post-data)
  (nconc
   (seq-map 'rest-post--format-field (list (list "title  " (cdr (assoc 'title post-data)))
                                           (list "author " (rest-post--username-from-user-id (cdr (assoc 'userId post-data))))))
   (list (concat "\n"
                 (cdr (assoc 'body post-data))))))

(defun rest-post--format-post (post-data)
  (seq-reduce (lambda (acc line)
                (concat acc line "\n"))
              (rest-post--data-to-printable-lines post-data)
              ""))

(defun rest-post--read-formatted-post (id)
  (rest-post--format-post (rest-api--read-post id)))

;;; TODO/FIXME wrong name for a public function
(defun rest-post--show-buffer (id)
  (rest-detail-show rest-post-buffer-name
                    (rest-post--read-formatted-post id)))

(provide 'rest-post)
