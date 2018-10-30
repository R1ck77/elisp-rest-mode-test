
(defun rest-utils--force-read-only ()
  (setq buffer-read-only t))

(defun rest-utils--propertize-text (string property value)
  (put-text-property 0 (length string) property value string)
  string)

(defun rest-utils--bold (string)
  (put-text-property 0 (length string) 'font-lock-face 'bold string)
  string)

(defun rest-utils--colorize (string color)
  (put-text-property 0 (length string) 'font-lock-face (list ':foreground color) string)
  string)

(defun rest-utils--yellow (string)
  (rest-utils--colorize string "yellow"))

(defun rest-utils--grey (string)
  (rest-utils--colorize string "gray"))

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
