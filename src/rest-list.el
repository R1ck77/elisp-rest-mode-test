(require 'rest-utils)

(defun rest-list--toggle-line ()
  (interactive)
  (let ((inhibit-read-only t))
    (rest-expand-toggle-text)))

(defun rest-list--bind-keys (refresh-action)
  (rest-open-bind-key)  
  (local-set-key (kbd "r") refresh-action)
  (local-set-key (kbd "q") 'rest-utils--close-buffer)
  (local-set-key (kbd "TAB") 'rest-list--toggle-line))

(defun rest-list-show (buffer-name content-function)
  (rest-utils--wipe-buffer-if-present buffer-name)
  (switch-to-buffer buffer-name)
  (font-lock-mode)
  (funcall content-function)
  (rest-utils--force-read-only)
  (lexical-let ((buffer-name buffer-name)
                (content-function))
   (rest-list--bind-keys (lambda ()
                           (interactive)
                           (rest-list-show buffer-name content-function)))))

(provide 'rest-list)
