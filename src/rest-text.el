(require 'rest-utils)

(defun rest-text-propertize-text (string property value)
  "Add the property to the whole string passed as argument

Overrides pre-existing properties"
  (put-text-property 0 (length string) property value string)
  string)

(defun rest-text--get-head-property-change (property string)
  (let ((at-0 (get-text-property 0 property string)))
    (if at-0
        (list (cons 0 at-0))
      (list))))

;;; TODO/FIXME Downright ugly
(defun rest-text--get-non-head-property-changes (property string)
  "Return a list of ranges for the property values in the string"
  (let ((positions (list))
        (index 0))
    (rest-utils-while-let (next-pos (next-single-property-change index property string))
      (setq positions (append positions (list (cons next-pos (get-text-property next-pos property string)))))
      (setq index next-pos)
      positions)))

(defun rest-text--get-property-changes (property string)
  (append (rest-text--get-head-property-change property string)
          (rest-text--get-non-head-property-changes property string)))

;;; TODO/FIXME Downright ugly
(defun rest-text-get-property-ranges (property string)
  (seq-map (lambda (x)
             (let ((start (car x))
                   (end (cadr x)))
               (list (car start) (car end) (cdr start))))
           (seq-partition (rest-text--get-property-changes property string) 2)))

(defun rest-text-apply-ranges (string property values)
  (seq-map (lambda (range)
             (put-text-property (car range) (elt range 1)  property (elt range 2) string))
           values)
  string)

(defun rest-text-propertize-text-light (string property value)
    "Add the property to the whole string passed as argument

Keeps the old values of the properties, if already present"
    (let ((old-properties (rest-text-get-property-ranges property string)))
      (rest-text-propertize-text string property value)
      (rest-text-apply-ranges string property old-properties)
      string))

(defun rest-text-bold (string)
  (put-text-property 0 (length string) 'font-lock-face 'bold string)
  string)

(defun rest-text-colorize (string color)
  (put-text-property 0 (length string) 'font-lock-face (list ':foreground color) string)
  string)

(defun rest-text-yellow (string)
  (rest-text-colorize string "yellow"))

(defun rest-text-grey (string)
  (rest-text-colorize string "gray"))

(defun rest-text-red (string)
  (rest-text-colorize string "red"))

(provide 'rest-text)
