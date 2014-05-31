module MCollective
  module Agent
    class Nitelite < RPC::Agent

      action "update-nodes" do
        cmd_output = []
        cmd_error = ""
        reply[:exitcode] = run("/usr/local/bin/update-node --kernel='#{request[:kernel]}' --initramfs='#{request[:initramfs]}'",
            :stdout => cmd_output,
            :stderr => cmd_error,
           )
        reply[:stdout] = cmd_output
        reply[:stderr] = cmd_error
      end

      action "emerge-app" do
        cmd_output = []
        cmd_error = ""
        reply[:exitcode] = run("/usr/bin/emerge -uv =#{request[:application]}::#{request[:overlay]}",
            :stdout => cmd_output,
            :stderr => cmd_error,
           )
        reply[:stdout] = cmd_output
        reply[:stderr] = cmd_error
      end

      action "eix-remote-update" do
        cmd_output = []
        cmd_error = ""
        reply[:exitcode] = run("/usr/bin/eix-remote update",
            :stdout => cmd_output,
            :stderr => cmd_error,
           )
        reply[:stdout] = cmd_output
        reply[:stderr] = cmd_error
      end

      action "eix-sync" do
        cmd_output = []
        cmd_error = ""
        reply[:exitcode] = run("/usr/bin/eix-sync",
            :stdout => cmd_output,
            :stderr => cmd_error,
           )
        reply[:stdout] = cmd_output
        reply[:stderr] = cmd_error
      end

      action "emerge-world" do
        cmd_output = []
        cmd_error = ""
        reply[:exitcode] = run("/usr/bin/emerge -DuvN --with-bdeps=y world",
            :stdout => cmd_output,
            :stderr => cmd_error,
           )
        reply[:stdout] = cmd_output
        reply[:stderr] = cmd_error
      end

      action "revdep-rebuild" do
        cmd_output = []
        cmd_error = ""
        reply[:exitcode] = run("/usr/bin/revdep-rebuild",
            :stdout => cmd_output,
            :stderr => cmd_error,
           )
        reply[:stdout] = cmd_output
        reply[:stderr] = cmd_error
      end

      action "perl-cleaner-all" do
        cmd_output = []
        cmd_error = ""
        reply[:exitcode] = run("/usr/sbin/perl-cleaner --all",
            :stdout => cmd_output,
            :stderr => cmd_error,
           )
        reply[:stdout] = cmd_output
        reply[:stderr] = cmd_error
      end

      action "python-updater" do
        cmd_output = []
        cmd_error = ""
        reply[:exitcode] = run("/usr/sbin/python-updater",
            :stdout => cmd_output,
            :stderr => cmd_error,
           )
        reply[:stdout] = cmd_output
        reply[:stderr] = cmd_error
      end

    end
  end
end
