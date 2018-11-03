
(defun rest-utils-force-read-only ()
  (setq buffer-read-only t))

(defun rest-utils-wipe-buffer-if-present (name)
  (let ((old-buffer (get-buffer name)))
    (when old-buffer
      (kill-buffer old-buffer))))

(defun rest-utils-context-buffer-bottom (name)
  (rest-utils-wipe-buffer-if-present name)
    (let ((buffer (get-buffer-create name)))    
      (display-buffer-in-side-window buffer nil)
      buffer))

(defun rest-utils-close-buffer ()
  (interactive)
  (let ((kill-buffer-query-functions nil))
    (kill-buffer)))

(defun rest-utils-string-end (string)
  (let ((string-length (length string)))
    (substring-no-properties string (- string-length 1) string-length)))

(defmacro rest-utils-let-when (def-block &rest body)
  "A when construct that binds the conditions to symbols

The body is executed only if at least one of the let forms is not nil"
  (declare (indent defun))
  (let ((variables (seq-map 'car def-block)))
    `(let ,def-block
       (if (or ,@variables)
           ,@body))))

(defmacro rest-utils-while-let (cond-block &rest body)
  "A while construct mixed with a let"
  (declare (indent defun))
  (let ((variable (car cond-block))
        (condition (cadr cond-block))
        (result (make-symbol "result")))
    `(let (,cond-block
           (,result nil))
       (while ,variable
         (setq ,result (progn
                         ,@body))
         (setq ,variable ,condition))
       ,result)))

(provide 'rest-utils)
