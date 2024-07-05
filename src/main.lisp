;;;; -------------------------------------------------------------------------
;;;; main

(in-package :main)

(defun run-for-wayland (args)
  "Run routine for Wayland."
  (princ "Running for Wayland, not implemented yet!"))

(defun connect-or-disconnect-for-xorg (primary-device devices-to-connect devices-to-disconnect position)
  "Connects all supplied connected displays, and disconnect the rest, for Xorg."
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
                                                                    " --auto " (get-xrandr-orientation position) " "
                                                                    "\"" primary-device "\" "))
                                                     devices-to-connect))
                                      (apply #'concatenate 'string
                                             (mapcar (lambda (d)
                                                       (concatenate 'string
                                                                    "--output "
                                                                    "\"" d "\""
                                                                    " --off "))
                                                     devices-to-disconnect))))))

(defun run-for-xorg (args)
  "Run routine for Xorg."
  (let* ((xrandr-devices (get-list-from-system "xrandr"))
         (connected-devices (concatenate 'list
                                         (mapcar (lambda (x)
                                                   (car (string-to-list x #\ )))
                                                 (remove-if-not (lambda (x)
                                                                  (string-equal (cadr (string-to-list x #\ )) "connected"))
                                                                xrandr-devices))))
         (disconnected-devices (concatenate 'list
                                            (mapcar (lambda (x)
                                                      (car (string-to-list x #\ )))
                                                    (remove-if-not (lambda (x)
                                                                     (string-equal (cadr (string-to-list x #\ )) "disconnected"))
                                                                   xrandr-devices))))
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
    (connect-or-disconnect-for-xorg primary-device
                                    devices-to-connect
                                    devices-to-disconnect
                                    (or (second args) "left"))))

(defun main ()
  "The main entry point to the program."
  (let* ((args (uiop:command-line-arguments))
         (session-type (get-result-from-system "echo $XDG_SESSION_TYPE")))
    (if (string-equal session-type
                      "wayland")
        (run-for-wayland args)
        (run-for-xorg args))))
