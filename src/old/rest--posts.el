(require 'rest-utils)


;;; TODO/FIXME too messy
(defun rest-posts--insert-posts ()
)



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

(defun add-update-hook ()
  (add-hook 'post-command-hook 'rest-posts--update-posts-on-page t t)
  (rest-utils--force-read-only-mode))

(provide 'rest--posts)
