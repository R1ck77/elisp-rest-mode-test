(defconst rest-mode-debug t)

(if rest-mode-debug
    (setq load-path (append load-path '("."))))

(require 'rest-state)
(require 'rest-posts)

(defun rest ()
  (interactive)
  (rest-state--init)
  (rest-posts--show-buffer))

(provide 'rest)
