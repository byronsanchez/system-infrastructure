class media {

  # TODO: For all classes, ensure that the use flags and other portage package
  # files are depended on by the corresponding packages.

  user { 'realtime':
    ensure => 'present',
    gid    => '1017',
    shell  => '/bin/false',
    uid    => '1017',
  }

  group { 'realtime':
    ensure => 'present',
    gid    => '1017',
  }

  # pulse is used for cava audio visualization and skype
  $pulse_files = [
    "/etc/pulse/client.conf",
    "/etc/pulse/daemon.conf",
    "/etc/pulse/default.pa",
    "/etc/pulse/system.pa",
  ]

  nl_files { $pulse_files:
    owner    => 'root',
    group    => 'root',
    mode     => 0644,
    requires  => Package["media-sound/pulseaudio"],
    source => 'media',
  }

  file { "/etc/asound.conf":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/asound.conf",
    source => "puppet:///files/media/etc/asound.conf",
  }

  file { "/etc/conf.d/jackd":
    ensure => present,
    mode => 0644,
    owner => "root",
    group => "root",
    source => "puppet:///files/media/etc/conf.d/jackd",
  }

  file { "/etc/security/limits.conf":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => 0644,
    path   => "/etc/security/limits.conf",
    source => "puppet:///files/media/etc/security/limits.conf",
  }

  file { "/etc/portage/package.accept_keywords/gentoo-studio":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/gentoo-studio",
    source => "puppet:///files/media/etc/portage/package.accept_keywords/gentoo-studio",
  }

  file { "/etc/portage/package.use/audacity":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/audacity",
    source => "puppet:///files/media/etc/portage/package.use/audacity",
  }

  file { "/etc/portage/package.use/gentoo-studio":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/gentoo-studio",
    source => "puppet:///files/media/etc/portage/package.use/gentoo-studio",
  }

  file { "/etc/portage/package.use/pulseaudio":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.use'],
    path => "/etc/portage/package.use/pulseaudio",
    source => "puppet:///files/media/etc/portage/package.use/pulseaudio",
  }

  file { "/usr/local/bin/loop2jack":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => 0755,
    path => "/usr/local/bin/loop2jack",
    source => "puppet:///files/media/usr/local/bin/loop2jack",
  }

  # TODO: Set the firewire device paths in the file. one line per firewire device
  # to find path, hook up the device, and look in /dev/fw*
  file { "/etc/udev/rules.d/fw.rules":
    ensure => present,
    owner => "root",
    group => "root",
    path => "/etc/udev/rules.d/fw.rules",
    source => "puppet:///files/media/etc/udev/rules.d/fw.rules",
  }

  file { "/etc/portage/package.accept_keywords/kino":
    ensure => present,
    owner => "root",
    group => "root",
    require => File['/etc/portage/package.accept_keywords'],
    path => "/etc/portage/package.accept_keywords/kino",
    source => "puppet:///files/media/etc/portage/package.accept_keywords/kino",
  }

  file { "/usr/local/bin/60ito24p":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode    => 0755,
    path   => "/usr/local/bin/60ito24p",
    source => "puppet:///files/media/usr/local/bin/60ito24p",
  }

  file { "/usr/local/bin/pipe-x264":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode    => 0755,
    path   => "/usr/local/bin/pipe-x264",
    source => "puppet:///files/media/usr/local/bin/pipe-x264",
  }

  file { "/usr/local/bin/multiplex":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode    => 0755,
    path   => "/usr/local/bin/multiplex",
    source => "puppet:///files/media/usr/local/bin/multiplex",
  }

  file { "/usr/local/bin/cpu-performance-casual":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => 0755,
    path => "/usr/local/bin/cpu-performance-casual",
    source => "puppet:///files/media/usr/local/bin/cpu-performance-casual",
  }

  file { "/usr/local/bin/cpu-performance-workstation":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => 0755,
    path => "/usr/local/bin/cpu-performance-workstation",
    source => "puppet:///files/media/usr/local/bin/cpu-performance-workstation",
  }

  file { "/usr/local/bin/gentoo-studio-destroy.sh":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => 0755,
    path => "/usr/local/bin/gentoo-studio-destroy.sh",
    source => "puppet:///files/media/usr/local/bin/gentoo-studio-destroy.sh",
  }

  file { "/usr/local/bin/gentoo-studio-initialize.sh":
    ensure => present,
    owner => "root",
    group => "root",
    mode    => 0755,
    path => "/usr/local/bin/gentoo-studio-initialize.sh",
    source => "puppet:///files/media/usr/local/bin/gentoo-studio-initialize.sh",
  }

  $packages = [
    "alsa-utils",
    "alsaequal",
    "alsa-oss",
    "alsa-plugins",
    "media-video/dvgrab",
    "media-video/kino",
    "media-video/cinelerra",
    "media-video/projectx",
    "media-video/x264-encoder",
    "media-sound/pulseaudio",
    "media-sound/pavucontrol",
    "media-sound/paprefs",
    # for converting ape files to flac on the off chance you need it (which you
    # have before which is why it's here now!)
    "app-cdr/bchunk",
    "app-cdr/cuetools",
    "media-sound/shntool",
    "media-sound/mac",
  ]

  $packages_require = [
    File["/etc/portage/package.accept_keywords/kino"],
    File["/etc/portage/package.use/pulseaudio"],
  ]

  package { $packages:
    ensure  => installed,
    require => $packages_require,
  }

  # TODO: This is stale, update with most recent
  $gentoo_studio_packages = [

    #
    # Audio and MIDI Software
    #

    "libraw1394",
    "libconfig",
    "libxmlpp",
    "PyQt4",

    # :NB: Before installing qjackctl, run:
    #
    # emerge --nodeps libffado
    #
    # These 2 have circular dependencies and it's a mess. Once libffado is installed
    # manually, qjackctl will work. KEEP THIS IN MIND FOR UPDATES THAT BREAK BECAUSE
    # OF QJACKCTL!!!
    #"libffado",
    "qjackctl",

    # A2jmidid is a daemon for exposing legacy ALSA sequencer applications to
    # JACK.
    "a2jmidid",
    # Dssi-vst will give you the vsthost program, which will allow you to run
    # many - but not all - VSTs on your 64-bit system.

    # TODO: Fails
    "dssi-vst",
    # Gscanbus is a bus scanning, testing, and topology visualizing tool for the
    # Linux IEEE1394 subsystem. This is useful to make sure your IEEE1394
    # devices are plugged in and detected by your system.
    "gscanbus",

    # Rosegarden is similar in functionality to Ardour. Rosegarden has a very
    # nice feature that Ardour doesn't: notation viewing and editing, which is
    # handy if you'd rather write on staves than in a tracker.
    "rosegarden",
    # Machina might not end up in your main menu. To fix this, open Main Menu ->
    # Settings -> Main Menu. Select the Multimedia category and create a new
    # launcher called Machina. There is an icon for it in
    # /usr/share/machina/machina.svg.
    "machina",
    # Audacity is a free crossplatform audio editor.
    "audacity",
    # Jamin is the JACK Audio Connection Kit (JACK) Audio Mastering interface.
    # TODO: Fails
    "jamin",
    "japa",
    # LinuxSampler (qsampler is the front-end) is a software audio sampler
    # engine with professional grade features.
    "qsampler",
    # Specimen is an open source, MIDI controllable audio sampler for Linux.
    "specimen",
    # Hydrogen is a Linux drum machine.
    "hydrogen",
    # drumkits libs for hydrogen
    "hydrogen-drumkits",
    # LMMS is a free alternative to popular programs such as FruityLoops, Cubase
    # and Logic.
    "media-sound/lmms",
    # SooperLooper is a live looping sampler capable of immediate loop
    # recording, overdubbing, multiplying, reversing and more.

    # TODO: This ebuild is also failing
     "sooperlooper",
    "chuck",

    #
    # LV2 Plugins
    #

    # Invada Studio Plugins contains: Delay, Dynamics, Filters, Reverb, Utility.
    "invada-studio-plugins-lv2",
    # midifilter-lv2 is a collection of LV2 plugins to filter MIDI events.
    "midifilter-lv2",
    # meters-lv2 is a collection of audio-level meters with GUI in LV2 plugin
    # format.
    "meters-lv2",
    # lv2vocoder is an LV2 vocoder plugin.
    "lv2vocoder",
    # lv2fil is a 4-band parametric EQ LV2 plugin.

    # TODO: Fails to find as valid package
     "lv2fil",
    # convoLV2 is an LV2 plugin to convolve audio signals with zero latency.
    "convoLV2",
    # balance-lv2 is an audio-plugin for stereo balance control with optional
    # per channel delay.
    "balance-lv2",
    # swh-lv2 is a collection of LV2 audio plugins and effects.
    "swh-lv2",
    "mda-lv2",
    "ams-lv2",

    #
    # Other Plugins
    #

    # Vamp is an audio processing plugin system for plugins that extract
    # descriptive information from audio data -- typically referred to as audio
    # analysis plugins or audio feature extraction plugins.
    "vamp-aubio-plugins",

    #
    # Soft Synths
    #

    # aeolus: Aeolus is a synthesised (i.e. not sampled) pipe organ emulator
    # that should be good enough to make an organist enjoy playing it. It is a
    # software synthesiser optimised for this job, with possibly hundreds of
    # controls for each stop, that enable the user to "voice" his instrument.
    "aeolus",
    # ams: AlsaModularSynth is a realtime modular synthesizer and effect
    # processor.
    "ams",
    # amsynth: amsynth is an analog modelling (a.k.a virtual analog) software
    # synthesizer. It mimics the operation of early analog subtractive
    # synthesizers with classic oscillator waveforms, envelopes, filter,
    # modulation and effects. The aim is to make it easy to create and modify
    # sounds.
    "amsynth",
    # bristol: Bristol is synth emulation package for a diverse range of vintage
    # synthesisers, electric pianos and organs. The application consists of a
    # multithreaded audio synthesizer and a user interface called brighton.

    # TODO: Bristol failed to build. Fix it.
    "bristol",
    # din: DIN Is Noise is a musical instrument for Windows, Mac OS X and
    # GNU/Linux. This is the latest free version. There is a commercial version
    # available from the web site.
    "din",
    # fluidsynth: FluidSynth is a real-time software synthesizer based on the
    # SoundFont 2 specifications. fluidsynth-dssi is a wrapper that allows
    # Fluidsynth to be used as a plugin in compatible sequencing software.
    "fluidsynth-dssi",
    # mx44: The Mx44 is a polyphonic multichannel MIDI realtime software
    # synthesizer. It is written in C and hand optimized for the (Intel) MMX
    # instruction set. It runs under Linux, using the JACK daemon and a kernel
    # modified for realtime performance.
    "mx44",
    # phasex: PHASEX is an experimental MIDI softsynth for Linux/ALSA/JACK with
    # a synth engine built around flexible phase modulation and flexible
    # oscillator/LFO sources. Modulations include AM, FM, offset PM, and wave
    # select. PHASEX comes equipped with multiple filter types and modes, a
    # stereo crossover delay and chorus with phaser, ADSR envelopes for both
    # amplifier and filter, realtime audio input processing capabilities, and
    # more. Inspirations come from a variety of analog and early digital MIDI
    # synthesizers from the '80s and '90s.
    "phasex",
    # psindustrializer: Power Station Industrializer is a program for generating
    # percussion sounds for musical purposes. This program is great for
    # generating new techno and industrial sounds. It also can produce chimes,
    # bubbles, gongs, hammer hits on different materials and so on.
    "psindustrializer",
    # psychosynth: The Psychosynth project aims to create an interactive modular
    # soft-synth inspired by the ideas of the Reactable.
    "psychosynth",
    # rtsynth: RTSynth is a midi event triggered real time synth for Linux.
    "rtsynth",
    # synthv1: synthv1 is an old-school all-digital 4-oscillator subtractive
    # polyphonic synthesizer with stereo fx.
    "synthv1",
    # triceratops-lv2: Triceratops is a polyphonic subtractive synthesizer
    # plugin for use with the LV2 architecture. There is no standalone version
    # and LV2 is required along with a suitable host (e.g. Jalv, Zynjacku,
    # Ardour, Qtractor).

    # TODO: This ebuild also fails. Fix it- old python.eclass has to be converted to python-r1 most likely
    "triceratops-lv2",
    # whysynth: WhySynth is a versatile softsynth which operates as a plugin for
    # the DSSI Soft Synth Interface.
    "whysynth",
    # xsynth-dssi: The xsynth-dssi package contains the Xsynth-DSSI plugin, a
    # classic-analog (VCOs-VCF-VCA) style software synthesizer with an editor
    # GUI.
    "xsynth-dssi",
    # zynaddsubfx: ZynAddSubFX is an open source software synthesizer capable of
    # making a countless number of instruments, from common heard-from expensive
    # hardware to interesting sounds that you'll boast of.
    "zynaddsubfx",

    #
    # JACK utils
    #

    # :NB: You most likely will have to run:
    #
    #  FETCHCOMMAND="/usr/bin/wget -t 5 -T 60 --passive-ftp --no-check-certificate -O \"\${DISTDIR}/\${FILE}\" \"\${URI}\"" emerge [package]
    #
    # This is because some of the package hosts SSL certificates aren't being
    # verified locally. Yes, this may mean manual invocation of these commands
    # will be required.

    "silentjack",
    "qjackmmc",
    "jackmixdesk",
    "jackminimix",
    "jackmeter",
    "jack_snapshot",
    "jack_mixer",
    "jack_delay",
    "jack_capture",
    # :NB: Run export ~LDFLAGS="$LDFLAGS -ldl~ prior to emerging jackEQ if it
    # fails
    "jackEQ",
    "jack-tools",
    # TODO: Fails
    "ac3jack",
    # TODO: Appears to collide with libsmf which is a dependency for drumgizmo
    "jack-smf-utils",
    "jack-rack",
    "jack-keyboard",

    #
    # Media players
    #

    # You'll need a good media player. Since each one has its pros and cons,
    # we'll install more than one.

    "vlc",
    "smplayer",
    "smplayer-skins",
    "smplayer-themes",
    "audacious",

    #
    # Audio format and other tools
    #

    # These are command line and GUI tools used for manipulating and converting
    # audio files.

    "dir2ogg",
    "flac-image",
    "flack",
    "flacon",
    "mp32ogg",
    "mp3unicode",
    "mp3wrap",
    "mp3info",
    "mp3gain",
    "mp3diags",
    "mp3check",
    "mp3asm",
    "mp3_check",
    "ogg2mp3",
    "oggtst",
    "redoflacs",
    "split2flac",
    "wavsplit",
    "wavbreaker",
    "vorbisgain",

    #
    # CD/DVD creation/ripping
    #

    # Gentoo Studio uses K3B as its CD burning program. It will pull in a
    # truckload of KDE stuff, but I personally think K3B is the easiest,
    # fully-featured CD-burning software on Linux. (I as in the doc in
    # gentoostudio.org)
    "k3b",

    #
    # Computer music programming
    #

    #
    # Streaming
    #

    #
    # Audio for videoi
    #

    #
    # Commercial software
    #

    #
    # Custom
    #

    # virtual midi keyboard
    "vmpk",
    # arpeggiator
    "qmidiarp",
    # non daw are modular daw tools
    "non-session-manager",
    "non-mixer",
    "non-sequencer",
    "non-timeline",
    # yoshimi is a fork of zynaddsubfx
    "yoshimi",
    # drumkit sampler + synthesizer
    "drumkv1",
    # an old school polyphonic sampler
    "samplv1",
    "drumgizmo",
    # An LV2 sampler plugin that (currently) plays hydrogen drum kits
    "drmr",
    # an lv2 drum sampler
    "fabla",
    # visualizer for jack connections
    "patchage",
    # an lfo arpeggiator
    "hypercyclic",
    # a modern soft synth
    "helm",
    # a nice retro soft synth
    "hexter",
    # a plugin host (useful for dssi, vsts, etc.)
    "carla",
    # a backend for sampling in linux
    "linuxsampler",
    # fantasia, a linuxsampler front-end
    "jsampler",

    #
    # possibly outdated
    #

    "jackd-init",
    "dss",
    "i-vst",
    "nekobee",
    "omins",
    "blop",
    "calf",
    "eq10q",
    "ll-plugins",
    "njl-plugins",
    "rev-plugins",
    "swh-plugins",
    "tap-plugins",
    "vcf",
    "vocoder-ladspa",
    "wah-plugins",
    "wasp",
    "minicomputer",
    "paulstretch",
    "qmidiroute",
    "qtractor",
    "rakarrack",
    "seq24",
  ]

  $gentoo_studio_packages_require = [
    Layman['proaudio'],
    Layman['nitelite-a'],
    File["/etc/portage/package.accept_keywords/gentoo-studio"],
    File["/etc/portage/package.use/gentoo-studio"],
  ]

  package { $gentoo_studio_packages:
    ensure  => installed,
    require => $gentoo_studio_packages_require,
  }

  layman { 'proaudio':
    ensure  => present,
    require => [
      Package[layman],
      File['/etc/layman/layman.cfg'],
      Exec['layman_sync'],
    ]
  }

  layman { 'bar':
    ensure  => present,
    require => [
      Package[layman],
      File['/etc/layman/layman.cfg'],
      Exec['layman_sync'],
    ]
  }

  service { 'alsasound':
    ensure => running,
    enable => true,
    require   => [
      Package[alsa-utils],
    ],
  }

}

