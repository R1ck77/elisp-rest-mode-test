(require 'url)
(require 'json)

(defvar schema "http")
(defvar host   "jsonplaceholder.typicode.com")

(defun rest-api--json-request (url)
  (with-current-buffer (url-retrieve-synchronously url)
    (goto-char url-http-end-of-headers)
    (forward-line)
    (let ((result (buffer-substring (point) (point-max))))
      (kill-buffer (current-buffer))
      (json-read-from-string result))))

;;; TODO/FIXME can't make POST work: why?! Try with CURL
(defun rest-api--request (path)
  (let ((url-request-method "GET"))    
    (rest-api--json-request (format "%s://%s%s" schema host path))))

(defun rest-api--read-posts ()
  (rest-api--request "/posts"))

(defun rest-api--read-user (user-id)
  (rest-api--request (format "/users/%d" user-id)))

(defun rest-api--read-post (post-id)
  (rest-api--request (format "/posts/%d" post-id)))

(provide 'rest-api)
