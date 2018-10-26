
(defun rest-utils--force-read-only ()
  (setq buffer-read-only t))

(defun rest-utils--propertize-text (string property value)
  (put-text-property 0 (length string) property value string)
  string)

(defun rest-utils--wipe-buffer-if-present (name)
  (let ((old-buffer (get-buffer name)))
    (when old-buffer
      (kill-buffer old-buffer))))


(provide 'rest-utils)
