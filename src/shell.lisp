;;;; -------------------------------------------------------------------------
;;;; Functions to interact with the shell

(in-package :shell)

(defun log-to-stdout (text)
  "Logs the supplied text to stdout."
  (princ text)
  (fresh-line))

(defun execute-in-system (command-string)
  "Executes the supplied command string in the underlying system."
  (uiop:run-program command-string
                    :input :interactive
                    :output :interactive
                    :error-output t
                    :ignore-error-status t))

(defun get-result-from-system (command-string)
  "Gets the result of execution of the supplied command string in the
underlying system."
  (uiop:run-program command-string
                    :output '(:string :stripped t)
                    :error-output t
                    :ignore-error-status t))

(defun get-list-from-system (command-string)
  "Executes the supplied command string in the underlying system and returns
a list."
  (string-to-list (get-result-from-system command-string)
                  #\Newline))
