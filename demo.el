(setq load-path (append load-path (list "src" "demo")))
(require 'rest)

(defun test-demo ()
  (interactive)
  (rest-state-init)
;  (rest-posts-show-buffer)
  )

