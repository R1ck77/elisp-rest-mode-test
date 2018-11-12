(require 'rest)
(require 'demo-state)

(defconst demo-author--buffer-name "*Author*")

(defconst demo-author--column-size 8)
(defconst demo-author--indent-size 2)

(defconst demo-author--address-template
  (list (cons 'street (rest-fmt-generate-plain-formatter "Street" demo-author--column-size demo-author--indent-size))
        (cons 'city (rest-fmt-generate-plain-formatter "City" demo-author--column-size demo-author--indent-size))))

(defconst demo-author--template
  (list (cons 'name (rest-fmt-generate-plain-formatter "Name" demo-author--column-size))
        (cons 'username (rest-fmt-generate-plain-formatter "User" demo-author--column-size))
        (cons 'phone (rest-fmt-generate-plain-formatter "Phone" demo-author--column-size))
        (cons 'email (rest-fmt-generate-plain-formatter "Email" demo-author--column-size))
        (cons 'website (rest-fmt-generate-plain-formatter "Website" demo-author--column-size))
        (cons 'address (rest-fmt-generate-hierarchic-formatter "Address"
                                                               (lambda (x) "[…]")
                                                               demo-author--column-size
                                                               (lambda (field-content)
                                                                 (cdr field-content))
                                                               demo-author--address-template
                                                               0
                                                               (lambda (x) "")))))

(defun demo-author--read-formatted-author (author-id)
  (rest-detail-format-data (demo-state-get-user-with-id author-id)
                           demo-author--template))

(defun demo-author-show-author (author-id)
  (rest-detail-show demo-author--buffer-name
                    (demo-author--read-formatted-author author-id)))

(provide 'demo-author)
