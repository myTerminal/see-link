;;;; -------------------------------------------------------------------------
;;;; main

(in-package :main)

(defun connect-or-disconnect (primary-device devices-to-connect devices-to-disconnect position)
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
                                                 devices-to-connect))
                                  (apply #'concatenate 'string
                                         (mapcar (lambda (d)
                                                   (concatenate 'string
                                                                "--output "
                                                                "\"" d "\""
                                                                " --off "))
                                                 devices-to-disconnect))))))

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
           (external-devices (cdr connected-devices))
           (devices-to-connect (if (string-equal (first args) "disconnect")
                                   nil
                                   external-devices))
           (devices-to-disconnect (if (string-equal (first args) "disconnect")
                                      (concatenate 'list
                                                   external-devices
                                                   disconnected-devices)
                                      disconnected-devices)))
      (connect-or-disconnect primary-device
                             devices-to-connect
                             devices-to-disconnect
                             (or (second args) "left")))))
