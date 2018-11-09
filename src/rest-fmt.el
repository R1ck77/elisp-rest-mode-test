(require 'rest-detail)

(defun rest-fmt--format-body (content)
  (concat "\n" content "\n"))

(defun rest-fmt-generate-body-formatter ()
  (lambda (field-content)
    (rest-fmt--format-body (cdr field-content))))

(defun rest-fmt--format-simple (title value padding indent)
  (concat
   (make-string indent ?\s)
   (format (concat "%-" (number-to-string padding)  "s %s\n") (rest-text-bold title) value)))

(defun rest-fmt-generate-formatter (f &rest extra-args)
  (lexical-let ((f f)
                (extra-args extra-args))
    (lambda (field-pair)
      (apply f (append (list field-pair) extra-args)))))

(defun rest-fmt-generate-indirect-formatter (f getter &rest extra-args)
  (lexical-let ((f f)
                (getter getter)
                (extra-args extra-args))
    (rest-fmt-generate-formatter (lambda (field-pair &rest extra-args)
                                   (apply f (append (list (funcall getter field-pair)) extra-args)))
                                 extra-args)))

(defun rest-fmt-generate-indirect-plain-formatter (title getter &optional padding indent)
  "Return a formatter that prints the fields as a pair like 'a   : getter(field)'"
  (rest-fmt-generate-indirect-formatter (lambda (content title padding indent)
                                          (rest-fmt--format-simple title content padding indent))
                                        getter title (or padding 0) (or indent 0)))

(defun rest-fmt-generate-plain-formatter (title padding &optional indent)
  "Return a formatter that prints the field as a simple pair 'a   : b'"
  (rest-fmt-generate-indirect-plain-formatter title 'cdr padding indent))

(defun rest-fmt-generate-clickable-formatter (f getter callback &rest extra-args)
  (rest-fmt-generate-indirect-formatter (lambda (content &rest extra-args)
                                          ;;; TODO/FIXME
                                          ;;; format with f and add the callback at this point!
                                          ;;; Return a function of lambda
                                          )
                                        getter
                                        extra-args))

(defun rest-fmt-generate-clickable-formatter (title getter padding callback &optional indent)
  (lexical-let ((callback callback)
                (getter getter))
    (rest-fmt-generate-indirect-plain-formatter title
                                                (lambda (field-content)
                                                  (lexical-let ((field-content field-content))
                                                    (rest-open-propertize (rest-text-yellow (funcall getter field-content))
                                                                          (lambda () (funcall callback field-content)))))
                                                padding
                                                indent)))

(defun rest-fmt-generate-expandable-formatter (title getter padding text-provider &optional indent extended-getter)
  (lexical-let ((text-provider text-provider)
                (base-formatter (rest-fmt-generate-indirect-plain-formatter title getter padding indent))
                (extended-formatter (rest-fmt-generate-indirect-plain-formatter title (or extended-getter getter) padding indent)))
    (lambda (field-content)
      (lexical-let ((normal-entry (funcall base-formatter field-content))
                    (expanded-entry (funcall extended-formatter field-content))
                    (field-content field-content))
        (rest-expand-convert-to-expandable-text normal-entry                                                
                                                (lambda ()
                                                  (funcall text-provider field-content))
                                                expanded-entry)))))

(defun rest-fmt-generate-hierarchic-formatter (title getter padding data-provider templates &optional indent extended-getter)
  (lexical-let ((data-provider data-provider)
                (templates templates))
    (rest-fmt-generate-expandable-formatter title getter padding
                                            (lambda (field-content)
                                              (rest-detail-format-data (funcall data-provider field-content)
                                                                    templates))
                                            indent
                                            extended-getter)))

(provide 'rest-fmt)
