(require 'rest-state)
(require 'rest-client)
(require 'rest--posts)

(defconst rest-mode-debug t)

(if rest-mode-debug
    (setq load-path (append load-path '("."))))


(defun rest-mode--format-post (post get-user-f)
  (let* ((user-for-id (funcall get-user-f (cdr (assoc 'userId post))))
         (user-name (cdr (assoc 'name user-for-id))))
    (format "%s: %s"
            user-name
            (cdr (assoc 'title post)))))

;;; TODO/FIXME maybe I need a generic memoization method instead…
(defun rest-mode--get-user-with-id (user-id)
  (let ((cached (assoc user-id rest-state--users)))
    (if cached
        cached
      (let ((user (rest-read-user user-id)))
        (setq rest-state--users (append rest-state--users (list (cons user-id user))))
        user))))

;;; TODO/FIXME too messy
(defun rest-mode--insert-posts ()
  (let* ((users '()))
    (lexical-let ((format-post (lambda (post)
                                 (rest-mode--format-post post 'rest-mode--get-user-with-id))))
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
  (rest-state--init)
  (switch-to-buffer "*Posts*")
  (rest-mode--insert-posts)
  (kill-all-local-variables)
  (setq major-mode 'rest-mode)
  (setq mode-name "ReSt")
  (use-local-map rest-mode-map)
  (run-hooks 'rest-mode-hook))

(provide 'rest)
