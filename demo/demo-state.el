(require 'rest)
(require 'demo-api)

(defvar demo-state--users nil)
(defvar demo-state--posts nil)

(defun demo-state-get-user-with-id (id))
(defun demo-state-get-post-with-id (id))

(defun demo-state-init ()
  (setq demo-state--users nil)
  (fset 'demo-state-get-user-with-id
        (rest-state--create-cached-getter demo-state--users
                                          'demo-api-read-user))
  (setq demo-state--posts nil)
  (fset 'demo-state-get-post-with-id 
        (rest-state--create-cached-getter demo-state--posts
                                          'demo-api-read-post)))

(demo-state-init)

(provide 'demo-state)
