(defmacro rest-state--create-cached-getter (cache function)
  (let ((value (make-symbol "value")))    
    `(lambda (id)
       (or (alist-get id ,cache)
           (let ((,value (funcall ,function id)))
             (setq ,cache (cons (cons id ,value) ,cache))
             ,value)))))

(provide 'rest-state)
