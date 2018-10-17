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

(defun add-my-hook ()
  (interactive)
  (add-hook 'post-command-hook 'something-happened t t))

(defun remove-my-hook ()
  (interactive)
  (remove-hook 'post-command-hook 'something-happened t))
