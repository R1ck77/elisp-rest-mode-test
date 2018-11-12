(require 'rest)

(defvar demo-api--schema "http")
(defvar demo-api--host   "jsonplaceholder.typicode.com")

;;; TODO/FIXME can't make POST work: why?! Try with CURL
(defun demo-api--request (path)
  (let ((url-request-method "GET"))    
    (rest-api-json-request (format "%s://%s%s" demo-api--schema demo-api--host path))))

(defun demo-api-read-posts ()
  (demo-api--request "/posts"))

(defun demo-api-read-user (user-id)
  (demo-api--request (format "/users/%d" user-id)))

(defun demo-api-read-post (post-id)
  (demo-api--request (format "/posts/%d" post-id)))

(provide 'demo-api)
