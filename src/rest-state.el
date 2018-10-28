(require 'rest-api)

(defvar rest-state--users nil)
(defvar rest-state--posts nil)

(defun rest-state--init ()
  (setq rest-state--users '())
  (setq rest-state--posts '()))

(defun rest-state--get-cached (cache function id)
  (let ((cached (assoc id (eval cache))))
    (or cached
      (let ((value (funcall function id)))
        (set cache (append (eval cache) (list (cons id value))))
        value))))

;;; TODO/FIXME use a macro with (fset cache ) to create the function
(defun rest-state--get-user-with-id (user-id)
  (rest-state--get-cached 'rest-state--users
                          'rest-api--read-user
                          user-id))

;;; TODO/FIXME use a macro with (fset cache ) to create the function
(defun rest-state--get-post-with-id (post-id)
  (rest-state--get-cached 'rest-state--posts
                          'rest-api--read-post post-id))

(provide 'rest-state)
