(require 'url)
(require 'json)

(defvar schema "https")
(defvar host "jsonplaceholder.typicode.com")

(defun rest--json-request (url)
  (with-current-buffer (url-retrieve-synchronously url)
    (goto-char url-http-end-of-headers)
    (forward-line)
    (let ((result (buffer-substring (point) (point-max))))
      (kill-buffer (current-buffer))
      (json-read-from-string result))))

;;; TODO/FIXME can't make POST work: why?! Try with CURL
(defun rest--request (path)
  (let ((url-request-method "GET"))    
    (rest--json-request (format "%s://%s%s" schema host path))))


(defun rest-read-posts ()
  (rest--request "/posts"))

(defun rest-read-user (user-id)
  (rest--request (format "/users/%d" user-id)))

(defun rest-read-post (post-id)
  (rest--request (format "/posts/%d" post-id)))

(provide 'rest-client)

