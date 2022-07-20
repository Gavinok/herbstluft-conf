#!/usr/bin/guile \
-l /home/gavinok/.config/herbsluftwm/util.scm -s
!#

(define HOME (getenv "HOME"))
(define CONFIG-HOME (string-append HOME "/.config/herbsluftwm/"))

;; keybindings
(define Mod "Mod4")

(hc 'emit_hook 'reload)

;; remove all existing keybindings
(hc 'keyunbind '--all)

(hset (frame_gap  26)
      (frame_border_active_color black)
      (frame_border_normal_color grey)
      (window_border_inner_color black)
      (window_border_width  3)
      (focus_follows_mouse  #t)
      (focus_stealing_prevention #t)
      (default_frame_layout max))

(hset
 (frame_active_opacity 100)
 (frame_normal_opacity 0)
 (frame_bg_transparent #t)
 (window_border_active_color black))

(hc 'set_monitors '1920x1080+0+0 '1920x1080+1920+0)

;; TODO
(hc 'set_attr 'tags.focus.title_height 3)

(hbind (Mod4-Shift-q quit)
       (Mod4-Shift-r reload)
       (Mod4-r remove)
       (Mod4-Shift-c close)
       (Mod4-q close_or_remove)
       (Mod4-Shift-Return spawn "st")
       (Mod4-Return spawn "emacsclient" -c -a emacs)
       (Mod4-w spawn "ducksearch")
       (Mod4-d spawn "dmenu_run")
       (Mod4-Shift-r reload))


;; Splitting
(hbind (Mod4-v split right)
       (Mod4-s split bottom))

(define dirbinds '((h . left)
		   (j . down)
		   (k . up)
		   (l . right)))
;; Basic movement
(map (lambda (key-dir)
       (let ((k (symbol->string (car key-dir)))
	     (dir (symbol->string (cdr key-dir))))
	 (hc-bind (list (string-append "Mod4-" k) 'spawn
			(string-append CONFIG-HOME "switchwin.scm") dir)
		  (list (string-append "Mod4-Shift-" k) 'shift dir)
		  (list (string-append "Mod4-Ctrl-" k) 'resize dir))))
     dirbinds)

(hbind (Mod4-Shift-z set_attr clients.focus.floating toggle)
       (Mod4-f fullscreen toggle))

(hbind (Mod4-m chain
	       ".-." lock
	       ".-." rotate
	       ".-." rotate
	       ".-." rotate
	       ".-." unlock))

;; General controls
(hbind (Mod4-Ctrl-f       spawn "cm" up 5)
       (Mod4-Ctrl-a       spawn "cm" down 5)
       (Mod4-Ctrl-Shift-f spawn "cm" up 10)
       (Mod4-Ctrl-Shift-a spawn "cm" down 10)

       (Mod4-Ctrl-s       spawn "xbacklight" -dec 5)
       (Mod4-Ctrl-d       spawn "xbacklight" -inc 5)
       (Mod4-Ctrl-Shift-s spawn "xbacklight" -dec 10)
       (Mod4-Ctrl-Shift-d spawn "xbacklight" -inc 10)

       (Mod4-equal spawn "menu_connection_manager.sh"))

(hbind (Mod4-Shift-m set_attr clients.focus.minimized #t))

;; TODO restore all minimized windows of the focused tag
;; (hc-bind Mod4-Ctrl-m foreach CLIENT "clients."
;; 	 sprintf MINATT "%c.minimized" CLIENT
;; 	 sprintf TAGATT "%c.tag" CLIENT and
;; 	 "," compare MINATT "=" "true"
;; 	 "," substitute FOCUS "tags.focus.name" compare TAGATT "=" FOCUS
;; 	 "," set_attr MINATT false)

;; (hbind (Mod4-space
;; 	or "," and "." compare tags.focus.curframe_wcount = 2
;; 	"." cycle_layout +1 vertical max grid
;; 	"," cycle_layout +1))

;; TODO
(hc 'mousebind 'Mod4-Button1 'move)
(hc 'mousebind 'Mod4-Button2 'zoom)
(hc 'mousebind 'Mod4-Button3 'resize)

(hbind (Mod4-Control-space split explode)
       (Mod4-Control-Return split auto)
       (Mod4-Tab cycle_monitor))

;; Cycle through tags
(hbind (Mod4-period use_index +1 --skip-visible)
       (Mod4-comma  use_index -1 --skip-visible)
       (Mod4-c pseudotile toggle))

(map (lambda (num)
       (hc 'add num))
     (iota 10))


(define tagbinds '((1 . 0)
		   (2 . 1)
		   (3 . 2)
		   (4 . 3)
		   (5 . 4)
		   (6 . 5)
		   (7 . 6)
		   (8 . 7)
		   (9 . 8)
		   (0 . 9)))

(map (lambda (key-dir)
       (let ((k (number->string (car key-dir)))
	     (tag (number->string (cdr key-dir))))
	 (hc-bind (list (string-append "Mod4-" k) 'use_index tag)
		  (list (string-append "Mod4-Shift-" k) 'move_index tag))))
     tagbinds)
;; TODO
;; # hc keybind $Mod-g spawn /home/gavinok/.config/herbsluftwm/tagpicker
;; (hc-bind '(Mod4-p spawn "/home/gavinok/.config/herbsluftwm/lemonbar"))

;; (hc 'set_attr 'theme.title_height 3)

;; # Execute this (e.g. from your autostart) to obtain basic key chaining like it
;; # is known from other applications like screen.
;; #
;; # E.g. you can press Mod1-i 1 (i.e. first press Mod1-i and then press the
;; # 1-button) to switch to the first workspace
;; #
;; # The idea of this implementation is: If one presses the prefix (in this case
;; # Mod1-i) except the notification, nothing is really executed but new
;; # keybindings are added to execute the actually commands (like use_index 0) and
;; # to unbind the second key level (1..9 and 0) of this keychain. (If you would
;; # not unbind it, use_index 0 always would be executed when pressing the single
;; # 1-button).

;; hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}

;; # Create the array of keysyms, the n'th entry will be used for the n'th
;; # keybinding
;; keys=( {1..9} 0 )

;; # Build the command to unbind the keys
;; unbind=(  )
;; for k in "${keys[@]}" Escape ; do
;;     unbind+=( , keyunbind "$k" )
;; done

;; # Add the actual bind, after that, no new processes are spawned when using that
;; # key chain. (Except the spawn notify-send of course, which can be deactivated
;; # by only deleting the appropriate line)

;; hc keybind $Mod-g chain \
;;     '->' spawn notify-send "Select a workspace number or press Escape" \
;;     '->' keybind "${keys[0]}" chain "${unbind[@]}" , use_index 0 \
;;     '->' keybind "${keys[1]}" chain "${unbind[@]}" , use_index 1 \
;;     '->' keybind "${keys[2]}" chain "${unbind[@]}" , use_index 2 \
;;     '->' keybind "${keys[3]}" chain "${unbind[@]}" , use_index 3 \
;;     '->' keybind "${keys[4]}" chain "${unbind[@]}" , use_index 4 \
;;     '->' keybind "${keys[5]}" chain "${unbind[@]}" , use_index 5 \
;;     '->' keybind "${keys[6]}" chain "${unbind[@]}" , use_index 6 \
;;     '->' keybind "${keys[7]}" chain "${unbind[@]}" , use_index 7 \
;;     '->' keybind "${keys[8]}" chain "${unbind[@]}" , use_index 8 \
;;     '->' keybind "${keys[9]}" chain "${unbind[@]}" , use_index 9 \
;;     '->' keybind Escape       chain "${unbind[@]}"

;; hc keybind $Mod-Shift-g chain \
;;     '->' spawn notify-send "Select a workspace number or press Escape" \
;;     '->' keybind "${keys[0]}" chain "${unbind[@]}" , move_index 0  \
;;     '->' keybind "${keys[1]}" chain "${unbind[@]}" , move_index 1 \
;;     '->' keybind "${keys[2]}" chain "${unbind[@]}" , move_index 2 \
;;     '->' keybind "${keys[3]}" chain "${unbind[@]}" , move_index 3 \
;;     '->' keybind "${keys[4]}" chain "${unbind[@]}" , move_index 4 \
;;     '->' keybind "${keys[5]}" chain "${unbind[@]}" , move_index 5 \
;;     '->' keybind "${keys[6]}" chain "${unbind[@]}" , move_index 6 \
;;     '->' keybind "${keys[7]}" chain "${unbind[@]}" , move_index 7 \
;;     '->' keybind "${keys[8]}" chain "${unbind[@]}" , move_index 8 \
;;     '->' keybind "${keys[9]}" chain "${unbind[@]}" , move_index 9 \
;;     '->' keybind Escape       chain "${unbind[@]}"
