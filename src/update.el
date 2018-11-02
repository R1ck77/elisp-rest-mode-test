
(defvar contents (list))

(defmacro add-content (var value)
  `(setq ,var (cons ,value ,var)))

(add-content contents 12)

(defmacro update-content (var function)
  `(setq ,var (cons (funcall ,function) ,var)))

(defun updater ()
  42)

(update-content contents 'updater)

