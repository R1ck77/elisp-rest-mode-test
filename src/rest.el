(require 'rest-state)
(require 'rest-posts)

(defun rest ()
  (interactive)
  (rest-state--init)
  (rest-posts--show-buffer))

(provide 'rest)
