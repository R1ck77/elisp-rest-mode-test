(defun rest-utils--current-line ()
  (buffer-substring-no-properties (line-end-position)
                                  (line-beginning-position)))


(defun rest-utils--is-last-line? ()
  (= (point-max)
     (line-end-position)))


(defun rest-utils-clear-current-line ()
  (delete-region (line-beginning-position) (line-end-position)))

(defun rest-utils--update-line (new-content)
  (rest-utils-clear-current-line)
  (insert new-content)
  (if (= (point) (point-max))
      (insert "\n")
    (forward-line))
  t)

(defun rest-utils--update-current-line (operator)
  (let* ((current-line (rest-utils--current-line))
         (last-line-detected (rest-utils--is-last-line?)))
    (let ((result (funcall operator current-line last-line-detected)))
      (if result
          (rest-utils--update-line result)        
        nil))))

(defun rest-utils-update-page (operator)
  "Execute operator on all potential lines in the visible buffer

The operator will be called for each line with the line content,
and an t if the line is the last line (or nil otherwise) for as
long as it takes to fill all lines potentially visible in the
buffer.

E.g. a buffer of 40 visible lines with only 3 text lines (the rest is empty):

    foo
    bar
    baz

Will be called 40 times, the first 2 with the lines contents and
nil, one time with \"baz\" and t, and the remaining 37 ones with
\"\" and t (unless the operator returns nil first)

The return value of operator is the output that will replace the
line, or nil to interrupt the recursion.

The content is re-displayed at each insertion"
  (save-excursion
    (let ((lines (window-body-height))
          (continue t)
          (current-line 0))
      (goto-char (window-start))
      (while (and continue (< current-line lines))
        (setq continue (rest-utils--update-current-line operator))
        (redisplay)
        (setq current-line (+ current-line 1))))))

(defun rest-utils--print-arguments-demo (content is-last-line)
  (format "%s:%s" content is-last-line))

(defun rest-utils--search-string-1-group (string regex)
  (let ((result (string-match regex string)))
    (if result
        (match-string 1 string))))

(provide 'rest-utils)
