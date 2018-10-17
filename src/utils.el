;;; just a test for now

(defun size-changed (frame)
  (message "Frame %s changed!" frame))

(add-hook 'window-size-change-functions 'size-changed)
(remove-hook 'window-size-change-functions 'size-changed)

(defun add-content ()
  (when(= (- (line-end-position) (line-beginning-position)) 0)
    (insert "new value"))
  (if (= (point) (point-max))
      (insert "\n")
    (forward-line)))

(defun something-happened ()
  (interactive)
  (save-excursion
    (let ((original-start (window-start)))
      (while (eq (window-start) original-start)
        (add-content)
        (redisplay)))))

(defun current-line ()
  (buffer-substring-no-properties (line-end-position)
                                  (line-beginning-position)))

(defun is-last-line? ()
  (= (point-max)
     (line-end-position)))

(defun clear-current-line ()
  ;;; TODO
  )

(defun update-current-line (operator)
  (let* ((current-line (thing-at-point 'line t))
         (last-line-detected (is-last-line?)))
    (let ((result (funcall operator current-line last-line-detected)))
      (if result
          (progn
            (clear-current-line)
            (insert result)
            (if (= (point) (point-max))
                (insert "\n")
              (forward-line))
            t)
        nil))))

(defun update-page (operator)
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
  (let ((original-start (window-start))
        (continue t))
    (while (and continue (eq (window-start) original-start))
      (setq continue (update-current-line))
      (redisplay))))

(defun add-my-hook ()
  (interactive)
  (add-hook 'post-command-hook 'something-happened t t))

(defun remove-my-hook ()
  (interactive)
  (remove-hook 'post-command-hook 'something-happened t))
