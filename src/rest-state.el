(require 'rest-api)

(defvar rest-state--users nil)
(defvar rest-state--posts nil)

(defun rest-state-init ()
  ;;; (nil. nil) necessary to make nconc work. assoc doesn't care
  (setq rest-state--users (cons nil nil))
  (setq rest-state--posts (cons nil nil)))

(defun rest-state--get-cached (cache function id)
  (let ((cached (assoc id cache)))
    (or cached
      (let ((value (funcall function id)))
        (nconc cache (list (cons id value)))
        value))))

(defun rest-state-get-user-with-id (user-id)
  (rest-state--get-cached rest-state--users
                          'rest-api-read-user user-id))

(defun rest-state-get-post-with-id (post-id)
  (rest-state--get-cached rest-state--posts
                          'rest-api-read-post post-id))

(provide 'rest-state)
