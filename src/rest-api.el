(require 'url)
(require 'json)

(defun rest-api-json-request (url)
  (with-current-buffer (url-retrieve-synchronously url)
    (goto-char url-http-end-of-headers)
    (forward-line)
    (let ((result (buffer-substring (point) (point-max))))
      (kill-buffer (current-buffer))
      (json-read-from-string result))))

(provide 'rest-api)
