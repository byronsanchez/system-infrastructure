class laptop {

  user { 'joy':
    ensure => 'present',
    gid    => '1016',
    shell  => '/bin/false',
    uid    => '1016',
  }

  group { 'joy':
    ensure => 'present',
    gid    => '1016',
  }

  # TODO: refine this file array style of resource declaration and apply it to
  # all classes where possible to reduce redundancy (eg. all conf.d type
  # files)
  #
  # TODO: start tracking all files for all managed apps

  $hibernate_files = [
    "/etc/hibernate/blacklisted-modules",
    "/etc/hibernate/common.conf",
    "/etc/hibernate/disk.conf",
    "/etc/hibernate/hibernate.conf",
    "/etc/hibernate/ram.conf",
    "/etc/hibernate/sysfs-disk.conf",
    "/etc/hibernate/sysfs-ram.conf",
    "/etc/hibernate/tuxonice.conf",
    "/etc/hibernate/ususpend-both.conf",
    "/etc/hibernate/ususpend-disk.conf",
    "/etc/hibernate/ususpend-ram.conf",
  ]

  nl_files { $hibernate_files:
    owner    => 'root',
    group    => 'root',
    mode     => 0644,
    requires  => Package["sys-power/hibernate-script"],
    source => 'laptop',
  }

  $laptop_mode_files = [
    "/etc/acpi/actions/lm_lid.sh",
    "/etc/laptop-mode/laptop-mode.conf",
    "/etc/laptop-mode/lm-profiler.conf",
    "/etc/laptop-mode/conf.d/ac97-powersave.conf",
    "/etc/laptop-mode/conf.d/auto-hibernate.conf",
    "/etc/laptop-mode/conf.d/battery-level-polling.conf",
    "/etc/laptop-mode/conf.d/bluetooth.conf",
    "/etc/laptop-mode/conf.d/configuration-file-control.conf",
    "/etc/laptop-mode/conf.d/cpufreq.conf",
    "/etc/laptop-mode/conf.d/dpms-standby.conf",
    "/etc/laptop-mode/conf.d/eee-superhe.conf",
    "/etc/laptop-mode/conf.d/ethernet.conf",
    "/etc/laptop-mode/conf.d/exec-commands.conf",
    "/etc/laptop-mode/conf.d/hal-polling.conf",
    "/etc/laptop-mode/conf.d/intel-hda-powersave.conf",
    "/etc/laptop-mode/conf.d/intel-sata-powermgmt.conf",
    "/etc/laptop-mode/conf.d/lcd-brightness.conf",
    "/etc/laptop-mode/conf.d/nmi-watchdog.conf",
    "/etc/laptop-mode/conf.d/pcie-aspm.conf",
    "/etc/laptop-mode/conf.d/runtime-pm.conf",
    "/etc/laptop-mode/conf.d/sched-mc-power-savings.conf",
    "/etc/laptop-mode/conf.d/sched-smt-power-savings.conf",
    "/etc/laptop-mode/conf.d/start-stop-programs.conf",
    "/etc/laptop-mode/conf.d/terminal-blanking.conf",
    "/etc/laptop-mode/conf.d/usb-autosuspend.conf",
    "/etc/laptop-mode/conf.d/video-out.conf",
    "/etc/laptop-mode/conf.d/wireless-ipw-power.conf",
    "/etc/laptop-mode/conf.d/wireless-iwl-power.conf",
    "/etc/laptop-mode/conf.d/wireless-power.conf",
  ]

  nl_files { $laptop_mode_files:
    owner    => 'root',
    group    => 'root',
    mode     => 0644,
    requires  => Package["app-laptop/laptop-mode-tools"],
    source => 'laptop',
  }

  file { "/etc/portage/package.use/laptop-mode-tools":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/laptop-mode-tools",
    source => "puppet:///files/laptop/etc/portage/package.use/laptop-mode-tools",
  }

  file { "/etc/portage/package.use/tp_smapi":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/tp_smapi",
    source => "puppet:///files/laptop/etc/portage/package.use/tp_smapi",
  }

  file { "/etc/acpi/events/default":
    ensure => present,
    owner => "root",
    group => "root",
    path => "/etc/acpi/events/default",
    source => "puppet:///files/laptop/etc/acpi/events/default",
  }

  file { "/usr/local/bin/toggle-bluetooth":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode    => 0755,
    path   => "/usr/local/bin/toggle-bluetooth",
    source => "puppet:///files/laptop/usr/local/bin/toggle-bluetooth",
  }

  file { "/etc/udev/hdaps-joy.rules":
    ensure => present,
    owner => "root",
    group => "root",
    path => "/etc/udev/hdaps-joy.rules",
    source => "puppet:///files/laptop/etc/udev/hdaps-joy.rules",
  }

  file { '/etc/udev/rules.d/z60_hdaps-joy.rules':
     ensure  => 'link',
     target  => '/etc/udev/hdaps-joy.rules',
     require => File['/etc/udev/hdaps-joy.rules'],
  }

  $packages = [
    "rfkill",
    "app-laptop/laptop-mode-tools",
    "net-wireless/bluez",
    "app-laptop/tp_smapi",
    "app-laptop/hdapsd",
    "wpa_supplicant",
    "pcmciautils",
    "sys-power/hibernate-script",
    "sys-power/suspend",
    "net-dialup/minicom",
  ]

  $packages_require = [
    File["/etc/portage/package.use/laptop-mode-tools"],
    File["/etc/portage/package.use/tp_smapi"],
  ]

  package { $packages:
    ensure  => installed,
    require => $packages_require,
  }


  service { laptop_mode:
    ensure    => running,
    enable => true,
    require   => [
      Package['app-laptop/laptop-mode-tools'],
    ],
  }

  service { hdapsd:
    ensure    => running,
    enable => true,
    require   => [
      Package['app-laptop/hdapsd'],
    ],
  }

  service { bluetooth:
    ensure    => running,
    enable => true,
    require   => [
      Package['net-wireless/bluez'],
    ],
  }

}

