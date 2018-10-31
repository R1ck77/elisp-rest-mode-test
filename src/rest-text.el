(defun rest-text-propertize-text (string property value)
  (put-text-property 0 (length string) property value string)
  string)

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

(provide 'rest-text)
