(provide 'rest-utils)

(defun rest-posts--format-post (post get-user-f)
  (let* ((id (cdr (assoc 'id post)))
         (user-for-id (funcall get-user-f (cdr (assoc 'userId post))))
         (user-name (cdr (assoc 'name user-for-id))))
    (format "* id:%d <%s> %s"
            id
            user-name
            (cdr (assoc 'title post)))))

(defun rest-posts--format-post-with-user (post)
  (rest-posts--format-post post 'rest-mode--get-user-with-id))

;;; TODO/FIXME too messy
(defun rest-posts--insert-posts ()
  (save-excursion 
    (let* ((users '()))
      (mapcar (lambda (post-as-string)
                (insert post-as-string)
                (insert "\n")
                (redisplay))
              (mapcar 'rest-posts--format-post-with-user (rest-read-posts))))))



;;; TODO/FIXME could be generalized for all page types if the format is the same
(defun rest-posts--read-id-at-line ()
  "Returns the id of the post at line if there is one, or -1 if it cannot be found"
  (string-to-number (or (rest-utils--search-string-1-group (rest-utils--current-line)
                                                           "^* id:\\([^ ]+\\)")
                        "-1")))

(defun rest-posts--is-valid-post-id? (post-id)
  (not (= post-id -1)))

(defun rest-posts--get-current-id (current-line)
  (save-excursion
    (let ((post-id-at-line (rest-posts--read-id-at-line)))
      (if (rest-posts--is-valid-post-id? post-id-at-line)
          post-id-at-line
        (+ 1 (rest-posts--get-previous-id))))))

(defun rest-posts--get-previous-id ()
  (let ((skipped-lines (forward-line -1)))
    (if (= skipped-lines -1)
        0
      (rest-posts--get-current-id (rest-utils--current-line)))))

(defun rest-posts--update-post-line (current-content is-last-line)
  (let ((current-id (rest-posts--get-current-id current-content)))
    (let ((post-content (rest-read-post current-id)))
      (if post-content
          (rest-posts--format-post post-content 'rest-mode--get-user-with-id)
        nil))))

(defun rest-posts--update-posts-on-page ()
  (rest-utils-update-page 'rest-posts--update-post-line))

(defun rest-posts--revert-to-read-mode ()
  (if (not view-read-only)
      (read-only-mode)))

(defun add-update-hook ()
  (add-hook 'post-command-hook 'rest-posts--update-posts-on-page t t)
  (add-hook 'read-only-mode-hook 'rest-posts--revert-to-read-mode t t))

(provide 'rest--posts)
