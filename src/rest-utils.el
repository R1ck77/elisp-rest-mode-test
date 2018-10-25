
(defun rest-utils--force-read-only ()
  (setq buffer-read-only t))

(defun rest-utils--propertize-text (string property value)
  (put-text-property 0 (length string) property value string)
  string)

(provide 'rest-utils)
