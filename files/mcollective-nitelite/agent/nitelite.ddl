metadata :name        => "nitelite",
         :description => "Update and manage nodes on the niteLite.io network",
         :author      => "Byron Sanchez",
         :license     => "GPL-2",
         :version     => "0.0.1",
         :url         => "http://hackbytes.com",
         :timeout     => 3600 

requires :mcollective => "2.2.1"

action "update-nodes", :description => "Updates kernel and initramfs" do
    display :always

    input :kernel,
          :prompt      => "Kernel Filename",
          :description => "The name of the kernel file to install",
          :type        => :string,
          :validation  => '^.+$',
          :optional    => false,
          :maxlength   => 150

    input :initramfs,
          :prompt      => "Initramfs Filename",
          :description => "The name of the initramfs file to install",
          :type        => :string,
          :validation  => '^.+$',
          :optional    => false,
          :maxlength   => 150

    output :stdout,
           :description => "The STDOUT",
           :display_as  => "Command Standard Output"

    output :stderr,
           :description => "The STDERR",
           :display_as  => "Command Standard Error"

    output :exitcode,
           :description => "The exit code from running the command",
           :display_as  => "Exit Code"

    summarize do
      aggregate summary(:stderr)
    end

end

action "emerge-app", :description => "Emerges the latest version of an app" do

    display :always

    input :application,
          :prompt      => "Application",
          :description => "The application to install",
          :type        => :string,
          :validation  => '^.+$',
          :optional    => false,
          :maxlength   => 150

    input :overlay,
          :prompt      => "Overlay",
          :description => "The overlay from which to install the package",
          :type        => :string,
          :validation  => '^.+$',
          :optional    => false,
          :maxlength   => 150

    output :stdout,
           :description => "The STDOUT}",
           :display_as  => "Command Standard Output"

    output :stderr,
           :description => "The STDERR",
           :display_as  => "Command Standard Error"

    output :exitcode,
           :description => "The exit code from running the command",
           :display_as  => "Exit Code"

    summarize do
      aggregate summary(:stderr)
    end

end

action "eix-remote-update", :description => "Adds overlays to the eix cache" do

    display :failed

    output :stdout,
           :description => "The STDOUT}",
           :display_as  => "Command Standard Output"

    output :stderr,
           :description => "The STDERR",
           :display_as  => "Command Standard Error"

    output :exitcode,
           :description => "The exit code from running the command",
           :display_as  => "Exit Code"

    summarize do
      aggregate summary(:stderr)
    end

end

action "eix-sync", :description => "Updates eix caches and indexes packages" do

    display :failed

    output :stdout,
           :description => "The STDOUT",
           :display_as  => "Command Standard Output"

    output :stderr,
           :description => "The STDERR",
           :display_as  => "Command Standard Error"

    output :exitcode,
           :description => "The exit code from running the command",
           :display_as  => "Exit Code"

    summarize do
      aggregate summary(:stderr)
    end

end

action "emerge-world", :description => "Updates all packages" do

    display :failed

    output :stdout,
           :description => "The STDOUT",
           :display_as  => "Command Standard Output"

    output :stderr,
           :description => "The STDERR",
           :display_as  => "Command Standard Error"

    output :exitcode,
           :description => "The exit code from running the command",
           :display_as  => "Exit Code"

    summarize do
      aggregate summary(:stderr)
    end

end

action "revdep-rebuild", :description => "Rebuilds reverse dependencies" do

    display :failed

    output :stdout,
           :description => "The STDOUT",
           :display_as  => "Command Standard Output"

    output :stderr,
           :description => "The STDERR",
           :display_as  => "Command Standard Error"

    output :exitcode,
           :description => "The exit code from running the command",
           :display_as  => "Exit Code"

    summarize do
      aggregate summary(:stderr)
    end

end

action "perl-cleaner-all", :description => "Rebuilds perl dependent packages" do

    display :failed

    output :stdout,
           :description => "The STDOUT",
           :display_as  => "Command Standard Output"

    output :stderr,
           :description => "The STDERR",
           :display_as  => "Command Standard Error"

    output :exitcode,
           :description => "The exit code from running the command",
           :display_as  => "Exit Code"

    summarize do
      aggregate summary(:stderr)
    end

end

action "python-updater", :description => "Rebuilds python dependent packages" do

    display :failed

    output :stdout,
           :description => "The STDOUT",
           :display_as  => "Command Standard Output"

    output :stderr,
           :description => "The STDERR",
           :display_as  => "Command Standard Error"

    output :exitcode,
           :description => "The exit code from running the command",
           :display_as  => "Exit Code"

    summarize do
      aggregate summary(:stderr)
    end

end

action "run-command", :description => "Runs a specified command" do

    display :always

    input :command,
          :prompt      => "Command",
          :description => "The command to execute",
          :type        => :string,
          :validation  => '^.+$',
          :optional    => false,
          :maxlength   => 512

    output :stdout,
           :description => "The STDOUT}",
           :display_as  => "Command Standard Output"

    output :stderr,
           :description => "The STDERR",
           :display_as  => "Command Standard Error"

    output :exitcode,
           :description => "The exit code from running the command",
           :display_as  => "Exit Code"

    summarize do
      aggregate summary(:stderr)
    end

end

