(defconst rest-mode-debug t)

(if rest-mode-debug
    (setq load-path (append load-path '("."))))

(require 'rest-client)

(defun rest-mode--format-post (post get-user-f)
  (let* ((user-for-id (funcall get-user-f (cdr (assoc 'userId post))))
         (user-name (cdr (assoc 'name user-for-id))))
    (format "%s: %s"
            user-name
            (cdr (assoc 'title post)))))

;;; TODO/FIXME maybe I need a generic memoization method instead…
(defun rest-mode--create-get-user-with-id ()  
  (lexical-let ((users-known '()))
    (lambda (user-id)
      (unless (assoc user-id users-known)
        (message "Reading user for id: %d" user-id)
        (let ((user (rest-read-user user-id)))
          (append users-known (list (cons user-id user)))
          user)))))

;;; TODO/FIXME too messy
(defun rest-mode--insert-posts ()
  (let* ((users '()))
    (lexical-let ((format-post (lambda (post)
                                 (rest-mode--format-post post (rest-mode--create-get-user-with-id)))))
     (mapcar (lambda (post-as-string)
               (insert post-as-string)
               (insert "\n"))
             (mapcar format-post (rest-read-posts))))))

(defvar rest-mode-hook nil "* List of functions to call when entering rest mode")

(defvar rest-mode-map nil "Keymap for rest major mode")

(if rest-mode-map
    nil
  (setq rest-mode-map (make-keymap))
;;  (define-key name rest-mode-map keysequence command)
  )

(defun rest-mode ()
  (interactive)
  (switch-to-buffer "*Posts*")
  (rest-mode--insert-posts)
  (kill-all-local-variables)
  (setq major-mode 'rest-mode)
  (setq mode-name "ReSt")
  (use-local-map rest-mode-map)
  (run-hooks 'rest-mode-hook))

(provide 'rest)
