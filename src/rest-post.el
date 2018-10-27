(require 'rest-state)
(require 'rest-utils)

(defconst rest-post-buffer-name "*Post Details*")

(defun rest-post--bind-keys ()
  (local-set-key (kbd "q") 'rest-utils--close-buffer))

(defun rest-post--format-field (title-value)
  (concat (rest-utils--bold (first title-value))
          (second title-value)))

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

(defun rest-post--show-buffer (id)
  (with-current-buffer (rest-utils--context-buffer-bottom rest-post-buffer-name)
    (font-lock-mode)
    (insert (rest-post--read-formatted-post id))
    (rest-utils--force-read-only)
    (rest-post--bind-keys)))

(provide 'rest-post)


