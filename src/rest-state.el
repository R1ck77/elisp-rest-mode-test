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

(provide 'rest-state)
