(require 'rest-text)

(defconst rest-open--tag-function-property 'rest-open--tag-function)

(defun rest-open-propertize (string f)
  "Tag the string to invoke the function f on enter"
  (rest-text-propertize-text string
                             rest-open--tag-function-property f))

(defun rest-open--get-tag ()
  (get-text-property (point) rest-open--tag-function-property))

(defun rest-open-link-at-point ()
  (interactive)
  (let ((open-function (rest-open--get-tag)))
    (when open-function
      (funcall open-function))))

(defun rest-open-bind-key (&optional key-string)
  (local-set-key (kbd (or key-string "RET")) 'rest-open-link-at-point))

(provide 'rest-open)
