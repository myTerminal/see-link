(defpackage :utils
  (:use :cl)
  (:export :string-to-list
           :get-xrandr-orientation))

(defpackage :shell
  (:use :cl)
  (:import-from :utils
                :string-to-list)
  (:export :log-to-stdout
           :execute-in-system
           :get-result-from-system
           :get-list-from-system))

(defpackage :main
  (:use :cl)
  (:import-from :utils
                :string-to-list
                :get-xrandr-orientation)
  (:import-from :shell
                :log-to-stdout
                :execute-in-system
                :get-result-from-system
                :get-list-from-system)
  (:export :main))
