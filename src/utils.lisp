;;;; -------------------------------------------------------------------------
;;;; Common utility helpers

(in-package :utils)

(defun string-to-list (input-string char)
  "Converts a string containing NewLine characters into a list of strings."
  (let* ((temp-chars '())
         (items '()))
    (labels ((to-string (chars)
               (coerce (reverse chars) 'string))
             (collect-item ()
               (push (to-string temp-chars) items)
               (setf temp-chars '())))
      (mapc (lambda (c)
              (cond ((eql c char) (collect-item))
                    (t (push c temp-chars))))
            (coerce input-string 'list))
      (collect-item)
      (reverse items))))

(defun get-orientation (position)
  "Gets direction string for xrandr."
  (if (string-equal position "left")
      "--left-of"
      "--right-of"))
