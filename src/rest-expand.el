(require 'rest-text)

(defconst rest-expand--expandable-property 'rest-expand--expadable)
(defconst rest-expand--collapsible-property 'rest-expand--collapsible)

(defun rest-expand-convert-to-expandable-text (content text-provider)
  "Return a toggleable header (the newline is added automatically).

The text can be toggled with the rest-expand--toggle-text
function: the expansion will be generated by the text-provider function."
  (or (string= (rest-utils-string-end content) "\n")
      (error "String should end with a newline!"))
  (rest-text-propertize-text content
                               rest-expand--expandable-property
                               text-provider))

(defun rest-expand--jump-to-header ()
  "Move up until a header is hit"
  (while (and (rest-expand--on-expanded-text?)
              (not (= -1 (forward-line -1))))))

(defun rest-expand--get-expanded-text ()
  (funcall
   (get-text-property (point)
                      rest-expand--expandable-property)))

(defun rest-expand--expand-text ()
  "Expand the text in the header"
  (let ((text (rest-expand--get-expanded-text)))
    (with-silent-modifications
      (save-excursion
       (goto-char (line-end-position))
       (if (not (looking-at-p "\n"))
           (insert "\n")) ;;; TODO/FIXME wrong text properties on "\n
       (forward-line)
       (insert (rest-text-propertize-text (concat text "\n")
                                            rest-expand--collapsible-property t))))))

(defun rest-expand--collapse-text ()
  "Collapse the text at point"
  (with-silent-modifications
    (save-excursion
     (forward-line)
     (while (rest-expand--on-expanded-text?)
       (delete-region (line-beginning-position) (+ (line-end-position) 1))))))

(defun rest-expand--on-expandable-text? ()
  (get-text-property (point)
                     rest-expand--expandable-property))

(defun rest-expand--on-expanded-text? ()
  (get-text-property (point)
                     rest-expand--collapsible-property))

(defun rest-expand--next-line-expanded? ()
  (save-excursion
    (and (not (= (forward-line) 1))
         (rest-expand--on-expanded-text?))))

(defun rest-expand--on-header-of-expanded-text? ()
  (and (rest-expand--on-expandable-text?)
         (rest-expand--next-line-expanded?)))

(defun rest-expand-toggle-text ()
  (interactive)
  (cond
   ((rest-expand--on-header-of-expanded-text?)
    (rest-expand--collapse-text))
   ((rest-expand--on-expandable-text?)
    (rest-expand--expand-text))
   ((rest-expand--on-expanded-text?)
    (rest-expand--jump-to-header)
    (rest-expand--collapse-text))))

(provide 'rest-expand)
