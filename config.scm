;; This is an operating system configuration template
;; for a "desktop" setup with StumpWM and Xfce

(use-modules (gnu) (gnu system nss) (srfi srfi-1) (gnu system shadow))
(use-service-modules desktop xorg networking ssh audio virtualization)
(use-package-modules certs screen ssh lisp wm fonts suckless android)

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
                                        "audio" "video"
					"adbusers")))
               %base-user-accounts))

  ;; This is where we specify system-wide packages.
  (packages (append (list
                     screen
                     sbcl
                     stumpwm
                     `(,stumpwm "lib")
		     sbcl-stumpwm-swm-gaps
                     font-dejavu
                     ;; for HTTPS access
                     nss-certs)
                    %base-packages))

  ;; Add Xfce and stumpwm---we can choose at the log-in screen
  ;; by clicking the gear.  Use the "desktop" services, which
  ;; include the X11 log-in service, networking with
  ;; NetworkManager, and more.
  (services (append (list
		     (udev-rules-service 'android android-udev-rules
					 #:groups '("adbusers"))
		     (service slim-service-type
			      (slim-configuration
			       (xorg-configuration
				(xorg-configuration
				 (keyboard-layout keyboard-layout)))))
		     ;; (service (screen-locker-service slock))
		     (service xfce-desktop-service-type)
		     (service mpd-service-type
			      (mpd-configuration
			       (user "daniel")))
		     (service qemu-binfmt-service-type
			      (qemu-binfmt-configuration
			       (platforms (lookup-qemu-platforms "arm" "aarch64"))))
		     (service openssh-service-type))
                    (modify-services %desktop-services
				     (delete gdm-service-type)
				     (delete modem-manager-service-type))))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
