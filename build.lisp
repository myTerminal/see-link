(load "package.lisp")
(load "src/utils.lisp")
(load "src/shell.lisp")
(load "src/main.lisp")

(sb-ext:save-lisp-and-die "see-link-bin"
                          :toplevel 'main:main
                          :executable t)
