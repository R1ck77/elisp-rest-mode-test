(setq load-path (append load-path (list "src" "demo")))

(require 'demo)

(defun test-demo ()
  (interactive)  
  (demo-show))

