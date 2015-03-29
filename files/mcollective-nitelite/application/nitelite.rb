module MCollective
  class Application::Nitelite < Application
    description "Manage and update nodes on the nitelite.io network"

    usage <<-END_OF_USAGE
mco nitelite [OPTIONS] <ACTION>

The ACTION can be one of the following:

    update-nodes            - updates kernel and initramfs
    eix-remote-update       - adds overlays to the eix cache
    eix-sync                - updates eix caches and indexes packages
    layman-sync             - syncs overlays
    emerge-world            - updates all packages
    revdep-rebuild          - rebuilds reverse dependencies
    perl-cleaner-all        - rebuilds perl dependent packages
    python-updater          - rebuilds python dependent packages
    emerge-app              - emerges the latest version of an application
    run-command             - runs the specified command
END_OF_USAGE

    option :yes,
           :arguments   => ["--yes", "-y"],
           :description => "Assume yes on any prompts",
           :type        => :bool

    option :kernel,
           :arguments   => ["--kernel KERNEL"],
           :description => "Name of kernel file to install",
           :type        => String

    option :initramfs,
           :arguments   => ["--initramfs INITRAMFS"],
           :description => "Name of initramfs file to install",
           :type        => String

    option :application,
           :arguments   => ["--application APPLICATION"],
           :description => "The application to install",
           :type        => String

    option :overlay,
           :arguments   => ["--overlay OVERLAY"],
           :description => "The overlay from which to install the package",
           :type        => String

    option :command,
           :arguments   => ["--command COMMAND"],
           :description => "The command to execute",
           :type        => String

    def handle_message(action, message, *args)
      messages = {1 => "Please specify a valid action",
                  2 => "Do you really want to operate on nodes unfiltered? (y/n): ",
                  3 => "Please supply a kernel filename and an initramfs filename",
                  4 => "Please supply an application name and an overlay name",
                  5 => "Please supply a command to run"}

      send(action, messages[message] % args)
    end

    def post_option_parser(configuration)
      if ARGV.size < 1
        handle_message(:raise, 1)
      else
        valid_actions = ['update-nodes', 'eix-remote-update', 'eix-sync', 'layman-sync', 'emerge-world', 'revdep-rebuild', 'perl-cleaner-all', 'python-updater', 'emerge-app', 'run-command']

        if valid_actions.include?(ARGV[0])
          configuration[:action] = ARGV.shift

          # If updating nodes, make sure kernel and initramfs file names are
          # passed
          if configuration[:action] == 'update-nodes'
            if configuration[:kernel].nil?
              handle_message(:raise, 3)
            end

            if configuration[:initramfs].nil?
              handle_message(:raise, 3)
            end
          end

          # If emerge-app, make sure overlay and app name are passed
          if configuration[:action] == 'emerge-app'
            if configuration[:application].nil?
              handle_message(:raise, 4)
            end

            if configuration[:overlay].nil?
              handle_message(:raise, 4)
            end
          end

          if configuration[:action] == 'run-command'
            if configuration[:command].nil?
              handle_message(:raise, 5)
            end
          end

        else
          handle_message(:raise, 1)
        end
      end
    end

    def validate_configuration(configuration)
      if Util.empty_filter?(options[:filter]) && !configuration[:yes]
        handle_message(:print, 2)

        STDOUT.flush

        exit(1) unless STDIN.gets.strip.match(/^(?:y|yes)$/i)
      end
    end

    def main
      # We have to change our process name in order to hide name of the
      # service we are looking for from our execution arguments. Puppet
      # provider will look at the process list for the name of the service
      # it wants to manage and it might find us with our arguments there
      # which is not what we really want ...
      $0 = 'mco'

      nitelite = rpcclient('nitelite')
      nitelite.progress = false

      if configuration[:action] == 'update-nodes'

        nitelite_result = nitelite.send(configuration[:action], :nitelite => configuration[:nitelite], :kernel => configuration[:kernel], :initramfs => configuration[:initramfs])

      elsif configuration[:action] == 'emerge-app'

        nitelite_result = nitelite.send(configuration[:action], :nitelite => configuration[:nitelite], :application => configuration[:application], :overlay => configuration[:overlay])

      elsif configuration[:action] == 'run-command'

        nitelite_result = nitelite.send(configuration[:action], :nitelite => configuration[:nitelite], :command => configuration[:command])

      else

        nitelite_result = nitelite.send(configuration[:action], :nitelite => configuration[:nitelite])

      end

      sender_width = nitelite_result.map{|s| s[:sender]}.map{|s| s.length}.max + 3
      pattern = "%%%ds: %%s" % sender_width

      nitelite_result.each do |result|
        if result[:statuscode] == 0
          if nitelite.verbose
            puts pattern % [result[:sender], result[:data][:status]]
          end
        else
          puts(pattern % [result[:sender], result[:statusmsg]])
        end
      end

      puts

      printrpcstats :summarize => true, :caption => "%s Nitelite results" % configuration[:action]
      halt(nitelite.stats)
    end
  end
end

