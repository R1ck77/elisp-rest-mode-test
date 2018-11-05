(require 'rest-utils)
(require 'rest-text)

(defun rest-detail-format-simple (title value padding)
  (format (concat "%-" (number-to-string padding)  "s %s\n") (rest-text-bold title) value))

(defun rest-detail-format-body (content)
  (concat "\n" content "\n"))

(defun rest-detail--bind-keys ()
  (local-set-key (kbd "q") 'rest-utils-close-buffer))

(defun rest-detail-generate-plain-formatter (title padding)
  "Return a formatter that prints the field as a simple pair 'a   : b'"
  (rest-detail-generate-indirect-plain-formatter title 'cdr padding))

(defun rest-detail-generate-indirect-plain-formatter (title getter padding)
  "Return a formatter that prints the fields as a pair like 'a   : getter(field)'"
  (lexical-let ((title title)
                (getter getter)
                (padding padding))
    (lambda (field-content)
      (let ((content (funcall getter field-content)))
        (rest-detail-format-simple title content padding)))))

(defun rest-detail-generate-body-formatter ()
  (lambda (field-content)
    (rest-detail-format-body (cdr field-content))))

(defun rest-detail--convert-field (field-content formatters)
  (let ((formatter (alist-get (car field-content) formatters)))
    (if formatter
        (funcall formatter field-content)
      "")))

(defun rest-detail-format-data (data formatters)
  (seq-reduce 'concat
   (seq-map (lambda (field-content)
              (rest-detail--convert-field field-content formatters))
            data)
   ""))

(defun rest-detail-show (buffer-name post-content)
  (with-current-buffer (rest-utils-context-buffer-bottom buffer-name)
    (font-lock-mode)
    (insert post-content)
    (rest-utils-force-read-only)
    (rest-detail--bind-keys)))

(provide 'rest-detail)
