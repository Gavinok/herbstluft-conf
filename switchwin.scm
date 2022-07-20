#!/usr/bin/guile \
-e main -s
!#
(load "./util.scm")
(define (is-emacs)
  (string= (hc 'get_attr 'clients.focus.class)
	   "Emacs"))

(define (emacs-winmove direction)
  (system* "emacsclient" "--eval" (string-append "(windmove-"   direction ")")))

(define (mvnt-cmd dir)
  (if (is-emacs)
      (emacs-winmove dir)))

;; Switch windows in emacs as if they are herbstluft frames
(define (main args)
  (let* ((direction (cadr args))
        (fallback (lambda (x) (hc 'focus x))))
    (if (is-emacs)
        (unless (zero? (emacs-winmove direction))
          (fallback direction))
        (fallback direction))))
