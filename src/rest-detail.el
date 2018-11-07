(require 'rest-utils)
(require 'rest-text)
(require 'rest-open)

(defun rest-detail-format-simple (title value padding indent)
  (concat
   (make-string indent ?\s)
   (format (concat "%-" (number-to-string padding)  "s %s\n") (rest-text-bold title) value)))

(defun rest-detail-format-body (content)
  (concat "\n" content "\n"))

(defun rest-detail--bind-keys ()
  (rest-open-bind-key)
  (local-set-key (kbd "q") 'rest-utils-close-buffer))

(defun rest-detail-generate-plain-formatter (title padding &optional indent)
  "Return a formatter that prints the field as a simple pair 'a   : b'"
  (rest-detail-generate-indirect-plain-formatter title 'cdr padding indent))

(defun rest-detail-generate-indirect-plain-formatter (title getter padding &optional indent)
  "Return a formatter that prints the fields as a pair like 'a   : getter(field)'"
  (lexical-let ((title title)
                (getter getter)
                (padding padding)
                (indent (or indent 0)))
    (lambda (field-content)
      (let ((content (funcall getter field-content)))
        (rest-detail-format-simple title content padding indent)))))

(defun rest-detail-generate-body-formatter ()
  (lambda (field-content)
    (rest-detail-format-body (cdr field-content))))

(defun rest-detail--convert-field (field-formatter-data)
  (funcall (cadr field-formatter-data) (cons (car field-formatter-data)
                                             (elt field-formatter-data 2))))

(defun rest-detail-generate-clickable-formatter (title getter padding callback &optional indent)
  (lexical-let ((callback callback)
                (getter getter))
    (rest-detail-generate-indirect-plain-formatter title
                                                   (lambda (field-content)
                                                     (lexical-let ((field-content field-content))
                                                       (rest-open-propertize (rest-text-yellow (funcall getter field-content))
                                                                             (lambda () (funcall callback field-content)))))
                                                   padding
                                                   indent)))

(defun rest-detail-generate-expandable-formatter (title getter padding text-provider &optional indent)
  (lexical-let ((text-provider text-provider)
                (base-formatter (rest-detail-generate-indirect-plain-formatter title getter padding indent)))
    (lambda (field-content)
      (lexical-let ((normal-entry (funcall base-formatter field-content))
                    (field-content field-content))
        (rest-expand-convert-to-expandable-text normal-entry                                                
                                                (lambda ()
                                                  (funcall text-provider field-content)))))))

(defun rest-detail-generate-hierarchic-formatter (title getter padding data-provider templates &optional indent)
  (lexical-let ((data-provider data-provider)
                (templates templates))
    (rest-detail-generate-expandable-formatter title getter padding
                                               (lambda (field-content)
                                                 (rest-detail-format-data (funcall data-provider field-content)
                                                                          templates))
                                               indent)))

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
    (save-excursion
      (insert post-content))
    (rest-utils-force-read-only)
    (rest-expand-bind-keys)  ;;; TODO/FIXME this is not the place, I should have a callback of sorts
    (rest-detail--bind-keys)))

(provide 'rest-detail)
