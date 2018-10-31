
(defun rest-utils--force-read-only ()
  (setq buffer-read-only t))

(defun rest-utils--wipe-buffer-if-present (name)
  (let ((old-buffer (get-buffer name)))
    (when old-buffer
      (kill-buffer old-buffer))))

(defun rest-utils--context-buffer-bottom (name)
  (rest-utils--wipe-buffer-if-present name)
    (let ((buffer (get-buffer-create name)))    
      (display-buffer-in-side-window buffer nil)
      buffer))

(defun rest-utils--close-buffer ()
  (interactive)
  (let ((kill-buffer-query-functions nil))
    (kill-buffer)))

(defun rest-utils-string-end (string)
  (let ((string-length (length string)))
    (substring-no-properties string (- string-length 1) string-length)))

(provide 'rest-utils)
