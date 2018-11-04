(require 'rest-state)

(defconst rest-author--buffer-name "*Author*")

(defun rest-author--print (author-data)
  (let ((result ""))
    (dolist (cell author-data)
      (setq result (concat result (format "%s\n" cell))))
    result))

(defun rest-author-show-author (author-id)
  (let ((author-data (rest-state-get-user-with-id author-id)))
      (rest-detail-show rest-author--buffer-name (rest-author--print author-data))))

(provide 'rest-author)
