(require 'rest-utils)
(require 'rest-text)

(defun rest-detail-format-simple (title value padding)
  (format (concat "%-" (number-to-string padding)  "s %s\n") (rest-text-bold title) value))

(defun rest-detail--bind-keys ()
  (local-set-key (kbd "q") 'rest-utils-close-buffer))

(defun rest-detail-format-data (data templates)
  (seq-map (lambda (field-content)
             (alist-get (car field-content) templates)
             )
           data))

(defun rest-detail-show (buffer-name post-content)
  (with-current-buffer (rest-utils-context-buffer-bottom buffer-name)
    (font-lock-mode)
    (insert post-content)
    (rest-utils-force-read-only)
    (rest-detail--bind-keys)))

(provide 'rest-detail)
