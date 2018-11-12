(require 'rest-utils)
(require 'rest-open)
(require 'rest-expand)

(defun rest-list--bind-keys (refresh-action)
  (rest-open-bind-key)
  (rest-expand-bind-keys)
  (local-set-key (kbd "r") refresh-action)
  (local-set-key (kbd "q") 'rest-utils-close-buffer))

(defun rest-list-show (buffer-name content-function &optional reset-function)
  (rest-utils-wipe-buffer-if-present buffer-name)
  (switch-to-buffer buffer-name)
  (font-lock-mode)
  (rest-utils-force-read-only)
  (lexical-let ((buffer-name buffer-name)
                (content-function content-function)
                (reset-function (or rest-function (lambda ()))))
    (rest-list--bind-keys (lambda ()
                            (interactive)
                            (funcall reset-function)
                            (rest-list-show buffer-name content-function reset-function))))
  (let ((inhibit-read-only t))
    (funcall content-function)))

(provide 'rest-list)
