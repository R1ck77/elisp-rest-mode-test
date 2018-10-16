(defvar rest-state--users nil)
(defvar rest-state--posts nil)

(defun rest-state--init ()
  (setq rest-state--users '())
  (setq rest-state--posts '()))

(provide 'rest-state)
