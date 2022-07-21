;; For running external commands and collecting output
(use-modules (ice-9 popen))
;; for read-line
(use-modules (ice-9 rdelim))

(define (hl-convert-type arg)
  (cond
   ((symbol? arg) (symbol->string arg))
   ((number? arg) (number->string arg))
   ((boolean? arg)
    (if arg
	"true"
	"false"))
   (#t arg)))

(define* (run-and-collect cmd-list)
  (let* ((port (open-input-pipe
		;; Join the command and arguments into a single string
		(string-concatenate
		 (map (lambda (str)
			(string-append str " "))
		      cmd-list))))
	 (str (read-line port)))
    (close-pipe port)
    str))

(define* (hc #:rest cmd)
  (run-and-collect (cons "herbstclient"
			 (map hl-convert-type cmd))))
;; Apply multple settings
(define* (hc-set #:key attr #:rest settings)
  (map (lambda (setting)
	 (apply hc (cons 'set setting)))
       settings))

;; Bind mutiple keys at once
(define* (hc-bind  #:rest bindings)
  (map (lambda (setting)
	 (apply hc (cons 'keybind setting)))
       bindings))


