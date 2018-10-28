(require 'rest-api)

(defvar rest-state--users nil)
(defvar rest-state--posts nil)

(defun rest-state--init ()
  (setq rest-state--users '())
  (setq rest-state--posts '()))


;;; TODO/FIXME maybe I need a generic memoization method instead…
(defun rest-state--get-user-with-id (user-id)
  (let ((cached (assoc user-id rest-state--users)))
    (if cached
        cached
      (let ((user (rest-api--read-user user-id)))
        (setq rest-state--users (append rest-state--users (list (cons user-id user))))
        user))))

;;; TODO/FIXME ^^^ same
(defun rest-state--get-post-with-id (post-id)
  (let ((cached (assoc post-id rest-state--posts)))
    (if cached
        cached
      (let ((post (rest-api--read-post post-id)))
        (setq rest-state--posts (append rest-state--posts (list (cons post-id post))))
        post))))


(provide 'rest-state)
