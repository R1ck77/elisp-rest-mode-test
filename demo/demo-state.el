(require 'rest-api)

(defvar rest-state--users nil)
(defvar rest-state--posts nil)

(defmacro rest-state--create-cached-getter (cache function)
  (let ((value (make-symbol "value")))    
    `(lambda (id)
       (or (alist-get id ,cache)
           (let ((,value (funcall ,function id)))
             (setq ,cache (cons (cons id ,value) ,cache))
             ,value)))))

(defun rest-state-get-user-with-id (id))
(defun rest-state-get-post-with-id (id))

(defun rest-state-init ()
  (setq rest-state--users nil)
  (fset 'rest-state-get-user-with-id
        (rest-state--create-cached-getter rest-state--users
                                          'rest-api-read-user))
  (setq rest-state--posts nil)
  (fset 'rest-state-get-post-with-id 
        (rest-state--create-cached-getter rest-state--posts
                                          'rest-api-read-post)))

(rest-state-init)

(provide 'rest-state)
