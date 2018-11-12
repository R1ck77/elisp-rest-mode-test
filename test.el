(setq load-path (append load-path (list "src" "demo")))
(require 'rest)
(require 'demo)

(defun test-demo ()
  (interactive)
  (rest-state-init)
  (demo-posts-show-buffer))

