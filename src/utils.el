;;; just a test for now

(defun size-changed (frame)
  (message "Frame %s changed!" frame))

(add-hook 'window-size-change-functions 'size-changed)
(remove-hook 'window-size-change-functions 'size-changed)

(defun current-line ()
  (buffer-substring-no-properties (line-end-position)
                                  (line-beginning-position)))

(defun is-last-line? ()
  (= (point-max)
     (line-end-position)))









(defun print-arguments (content last-line)
  (print "\n\n\n\n")
  (format "%s:%s" content last-line))

(defun update-test ()
  (interactive)
  (update-page 'print-arguments))

(defun add-my-hook ()
  (interactive)
  (add-hook 'post-command-hook 'update-test t t))

(defun remove-my-hook ()
  (interactive)
  (remove-hook 'post-command-hook 'update-test t))
