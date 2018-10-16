f;;; just a test for now

(defun size-changed (frame)
  (message "Frame %s changed!" frame))

(add-hook 'window-size-change-functions 'size-changed)
(remove-hook 'window-size-change-functions 'size-changed)

(defun something-happened ()
  (save-excursion
    (while-no-input (redisplay)
        (let ((original-start (window-start)))
          (while (eq (window-start) original-start)
            (if (= (- (line-end-position) (line-beginning-position)) 0)
                (insert "new value"))
            (insert "\n"))))))

(defun add-my-hook ()
  (interactive)
  (add-hook 'post-command-hook 'something-happened t t))

(defun remove-my-hook ()
  (interactive)
  (remove-hook 'post-command-hook 'something-happened t))
