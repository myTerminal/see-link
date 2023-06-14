;;;; -------------------------------------------------------------------------
;;;; main

(in-package :main)

(defun connect-external-displays (primary-device external-devices disconnected-devices position)
  "Connects all supplied connected displays."
  (if (not (member position '("left" "right") :test #'string-equal))
      (princ "Please specify \"left/right\"!")
      (log-to-stdout (concatenate 'string
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
                                                 external-devices))
                                  (apply #'concatenate 'string
                                         (mapcar (lambda (d)
                                                   (concatenate 'string
                                                                "--output "
                                                                "\"" d "\""
                                                                " --off "))
                                                 disconnected-devices))))))

(defun disconnect-external-displays (primary-device disconnected-devices)
  "Connects all supplied connected displays."
  (log-to-stdout (concatenate 'string
                              "xrandr --output "
                              "\"" primary-device "\""
                              " --auto "
                              (apply #'concatenate 'string
                                     (mapcar (lambda (d)
                                               (concatenate 'string
                                                            "--output "
                                                            "\"" d "\""
                                                            " --off "))
                                             disconnected-devices)))))

(defun main ()
  "The main entry point to the program."
  (let* ((args (uiop:command-line-arguments)))
    (Let* ((connected-devices (concatenate 'list
                                           (mapcar (lambda (x)
                                                     (car (string-to-list x #\ )))
                                                   (remove-if-not (lambda (x)
                                                                    (string-equal (cadr (string-to-list x #\ )) "connected"))
                                                                  (get-list-from-system "xrandr")))))
           (disconnected-devices (concatenate 'list
                                              (mapcar (lambda (x)
                                                        (car (string-to-list x #\ )))
                                                      (remove-if-not (lambda (x)
                                                                       (string-equal (cadr (string-to-list x #\ )) "disconnected"))
                                                                     (get-list-from-system "xrandr")))))
           (primary-device (car connected-devices))
           (external-devices (cdr connected-devices)))
      (if (or (string-equal (first args) "disconnect") (null connected-devices))
          (disconnect-external-displays primary-device
                                        disconnected-devices)
          (connect-external-displays primary-device
                                     external-devices
                                     disconnected-devices
                                     (or (second args) "left"))))))
