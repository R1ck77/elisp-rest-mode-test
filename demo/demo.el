(require 'rest)
(require 'demo-api)
(require 'demo-state)
(require 'demo-author)
(require 'demo-post)
(require 'demo-posts)

(defun demo-show ()
  (interactive)
  (demo-state-init)
  (demo-posts-show-buffer))

(provide 'demo)
