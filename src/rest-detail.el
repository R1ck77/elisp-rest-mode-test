(require 'rest-utils)
(require 'rest-text)
(require 'rest-open)

(defun rest-detail-format-simple (title value padding)
  (format (concat "%-" (number-to-string padding)  "s %s\n") (rest-text-bold title) value))

(defun rest-detail-format-body (content)
  (concat "\n" content "\n"))

(defun rest-detail--bind-keys ()
  (rest-open-bind-key)
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

(defun rest-detail--convert-field (field-formatter-data)
  (funcall (cadr field-formatter-data) (cons (car field-formatter-data)
                                             (elt field-formatter-data 2))))

(defun rest-detail-generate-clickable-formatter (title getter padding callback)
  (lexical-let ((callback callback)
                (getter getter))
    (rest-detail-generate-indirect-plain-formatter title
                                                   (lambda (field-content)
                                                     (lexical-let ((field-content field-content))
                                                       (rest-open-propertize (rest-text-yellow (funcall getter field-content))
                                                                             (lambda () (funcall callback field-content)))))
                                                   padding)))

(defun rest-detail--not-nilp (x)
  (not (null x)))

(defun rest-detail--get-field-for-formatter (field-formatter all-data)
  "Accepts a cons '(field . formatter) and the assoc. list of data, returns (field formatter data-content)

nil is returned if there is no data for the formatter"
  (let* ((field (car field-formatter))
         (field-content (alist-get field all-data)))
    (and field-content (list field (cdr field-formatter) field-content))))

(defun rest-detail-format-data (data formatters)
  (seq-reduce 'concat
              (seq-map
               'rest-detail--convert-field 
               (seq-filter
                'rest-detail--not-nilp
                (seq-map (lambda (formatter-data)
                           (rest-detail--get-field-for-formatter formatter-data data))
                         formatters)))
              ""))

(defun rest-detail-show (buffer-name post-content)
  (with-current-buffer (rest-utils-context-buffer-bottom buffer-name)
    (font-lock-mode)
    (insert post-content)
    (rest-utils-force-read-only)
    (rest-detail--bind-keys)))

(provide 'rest-detail)
