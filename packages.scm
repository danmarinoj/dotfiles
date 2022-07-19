;; This "manifest" file can be passed to 'guix package -m' to reproduce
;; the content of your profile.  This is "symbolic": it only specifies
;; package names.  To reproduce the exact same profile, you also need to
;; capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(specifications->manifest
 (list "emacs"				; apps
       "freecad"
       "icecat"
       "ungoogled-chromium"
       "transmission:gui"
       "vlc"
       "irssi"				; network
       "wget"
       "lynx"
       "openssh"
       "emacs-slime"			; development
       "emacs-magit"
       "emacs-solarized-theme"
       "sbcl"
       "git"
       "rxvt-unicode"
       "ncmpcpp"			; music
       "mpd-mpc"
       "tree"				; utils
       "feh"
       "screenfetch"
       "htop"
       "unzip"
       "xrdb"				; misc
       "ncurses"))