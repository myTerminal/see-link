;;;; -------------------------------------------------------------------------
;;;; main

(in-package :main)

(defun connect-external-displays (primary-device external-devices position)
  "Connects all supplied connected displays."
  (if (not (member position '("left" "right") :test #'string-equal))
      (princ "Please specify \"left/right\"!")
      (execute-in-system (concatenate 'string
                                      "xrandr --output "
                                      "\"" primary-device "\""
                                      " --auto "
                                      (apply #'concatenate 'string
                                             (mapcar (lambda (d)
                                                       (concatenate 'string
                                                                    "--output "
                                                                    "\"" d "\""
                                                                    " --auto " (get-orientation position) " "
                                                                    "\"" primary-device "\" "))
                                                     external-devices))))))

(defun disconnect-external-displays (primary-device external-devices)
  "Connects all supplied connected displays."
  (execute-in-system (concatenate 'string
                                  "xrandr --output "
                                  "\"" primary-device "\""
                                  " --auto "
                                  (apply #'concatenate 'string
                                         (mapcar (lambda (d)
                                                   (concatenate 'string
                                                                "--output "
                                                                "\"" d "\""
                                                                " --off "))
                                                 external-devices)))))

(defun main ()
  "The main entry point to the program."
  (let* ((args (uiop:command-line-arguments)))
    (if (not (member (first args) '("connect" "disconnect") :test #'string-equal))
        (princ "Please specify \"connect/disconnect\"!")
        (Let* ((connected-devices (concatenate 'list
                                               (mapcar (lambda (x)
                                                         (car (string-to-list x #\ )))
                                                       (remove-if-not (lambda (x)
                                                                        (string-equal (cadr (string-to-list x #\ )) "connected"))
                                                                      (get-list-from-system "xrandr")))))
               (primary-device (car connected-devices))
               (external-devices (cdr connected-devices))
               (orientation (second args)))
          (if (string-equal (car args) "connect")
              (connect-external-displays primary-device external-devices orientation)
              (disconnect-external-displays primary-device external-devices))))))
