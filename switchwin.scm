#!/usr/bin/guile \
-l /home/gavinok/.config/herbsluftwm/util.scm -e main -s
!#

(define (window-is-emacs?)
  (let ((res (hc 'get_attr 'clients.focus.class)))
    (and (string? res) ; Since it can simply return an #:<eof>
         (string= res "Emacs"))))

(define (emacs-winmove direction)
  (system* "emacsclient" "--eval"
           (format #f "(windmove-~a)" direction)))

(define (mvnt-cmd dir)
  (if (window-is-emacs?)
      (emacs-winmove dir)))

;; Switch windows in emacs as if they are herbstluft frames
(define (main args)
  (let* ((direction (cadr args))
        (fallback (lambda (x) (hc 'focus x))))
    (if (window-is-emacs?)
        (unless (zero? (emacs-winmove direction))
          (fallback direction))
        (fallback direction))))
