(defconst rest-mode-debug t)

(if rest-mode-debug
    (setq load-path (append load-path '("."))))

(require 'rest-state)
(require 'rest-client)
(require 'rest--posts)

;;; TODO/FIXME maybe I need a generic memoization method instead…
(defun rest-mode--get-user-with-id (user-id)
  (let ((cached (assoc user-id rest-state--users)))
    (if cached
        cached
      (let ((user (rest-read-user user-id)))
        (setq rest-state--users (append rest-state--users (list (cons user-id user))))
        user))))



;;;; Boilerplate code
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
  (rest-posts--insert-posts)
  (rest-utils--force-read-only-mode)
  (kill-all-local-variables)
  (setq major-mode 'rest-mode)
  (setq mode-name "ReSt")
  (use-local-map rest-mode-map)
  (run-hooks 'rest-mode-hook))

(provide 'rest)
