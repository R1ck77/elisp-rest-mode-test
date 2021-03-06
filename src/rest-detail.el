(require 'rest-utils)
(require 'rest-text)
(require 'rest-open)

(defun rest-detail--bind-keys ()
  (rest-open-bind-key)
  (local-set-key (kbd "q") 'rest-utils-close-buffer))

(defun rest-detail--not-nilp (x)
  (not (null x)))

(defun rest-detail--get-field-for-formatter (field-formatter all-data)
  "Accepts a cons '(field . formatter) and the assoc. list of data, returns (field formatter data-content)

nil is returned if there is no data for the formatter"
  (let* ((field (car field-formatter))
         (field-content (alist-get field all-data)))
    (and field-content (list field (cdr field-formatter) field-content))))

(defun rest-detail--convert-field (field-formatter-data)
  (funcall (cadr field-formatter-data) (cons (car field-formatter-data)
                                             (elt field-formatter-data 2))))

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
