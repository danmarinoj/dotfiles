;; This is an operating system configuration template
;; for a "desktop" setup with StumpWM and Xfce

(use-modules (gnu) (gnu system nss) (srfi srfi-1))
(use-service-modules desktop xorg networking ssh audio)
(use-package-modules certs screen ssh lisp wm fonts)

(operating-system
  (host-name "symphony")
  (timezone "America/New_York")
  (locale "en_US.utf8")

  ;; Choose US English keyboard layout.
  (keyboard-layout (keyboard-layout "us" #:options '("ctrl:nocaps")))

  ;; Use the UEFI variant of GRUB with the EFI System
  ;; Partition mounted on /boot/efi.
  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (target "/dev/sda")))

  (file-systems (append
                 (list (file-system
                         (device (file-system-label "my-root"))
                         (mount-point "/")
                         (type "ext4"))
                       (file-system
                         (device (uuid "a281ba27-3469-4925-9b77-9a0e7eca9d4a"))
                         (mount-point "/home/")
                         (type "ext4")))
                 %base-file-systems))

  ;; Create user `daniel'
  (users (cons (user-account
                (name "daniel")
                (comment "Primary user")
                (group "users")
                (supplementary-groups '("wheel" "netdev"
                                        "audio" "video")))
               %base-user-accounts))

  ;; This is where we specify system-wide packages.
  (packages (append (list
                     screen
                     sbcl
                     stumpwm
		     sbcl-stumpwm-swm-gaps
                     `(,stumpwm "lib")
                     font-dejavu
                     ;; for HTTPS access
                     nss-certs)
                    %base-packages))

  ;; Add Xfce and stumpwm---we can choose at the log-in screen
  ;; by clicking the gear.  Use the "desktop" services, which
  ;; include the X11 log-in service, networking with
  ;; NetworkManager, and more.
  (services (append (list (service slim-service-type (slim-configuration
						      (xorg-configuration
						       (xorg-configuration
							(keyboard-layout keyboard-layout)))))
			  (service xfce-desktop-service-type)
			  (service mpd-service-type
				   (mpd-configuration
				    (outputs
				     (list (mpd-output
					    (name "iFi (by AMR) HD USB Audio")
					    (type "alsa")
					    (mixer-type 'null)
					    (extra-options
					     `((device . "hw:1"))))))))
			  (service openssh-service-type))
                    (modify-services %desktop-services
				     (delete gdm-service-type))))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
