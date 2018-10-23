(defconst rest-mode-debug t)

(if rest-mode-debug
    (setq load-path (append load-path '("."))))

(require 'rest-state)
(require 'rest-client)
(require 'rest--posts)




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
  (kill-all-local-variables)
  (setq major-mode 'rest-mode)
  (setq mode-name "ReSt")
  (use-local-map rest-mode-map)
  (run-hooks 'rest-mode-hook))

(provide 'rest)
