(require 'rest-state)
(require 'rest-detail)

(defconst rest-author--buffer-name "*Author*")

(defconst rest-author--column-size 8)

(defconst rest-author--template
  (list (cons 'name (rest-detail-generate-plain-formatter "Name" rest-author--column-size))
        (cons 'username (rest-detail-generate-plain-formatter "User" rest-author--column-size))
        (cons 'phone (rest-detail-generate-plain-formatter "Phone" rest-author--column-size))
        (cons 'email (rest-detail-generate-plain-formatter "Email" rest-author--column-size))
        (cons 'website (rest-detail-generate-plain-formatter "Website" rest-author--column-size))
        (cons 'address (rest-detail-generate-expandable-formatter "Address"
                                                                  (lambda (x)
                                                                    "")
                                                                  rest-author--column-size                                                                  
                                                                  (lambda (field-content)
                                                                    "foo\nbar\nbaz")))))

(defun rest-author--read-formatted-author (author-id)
  (rest-detail-format-data (rest-state-get-user-with-id author-id)
                           rest-author--template))

(defun rest-author-show-author (author-id)
  (rest-detail-show rest-author--buffer-name
                    (rest-author--read-formatted-author author-id)))

(provide 'rest-author)
