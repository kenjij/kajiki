module Kajiki

  # Available commands.
  SUB_COMMANDS = %w(start stop)

  # Description strings for help display.
  OPT_DESCS = {
    banner: "Usage: #{File.basename($0)} [options] {#{SUB_COMMANDS.join('|')}}",
    address: 'Bind to address',
    daemonize: 'Run in the background',
    error: 'Output error to file',
    group: 'Group to run as',
    log: 'Log output to file',
    pid: 'Store PID to file',
    port: 'Use port',
    user: 'User to run as'
  }

  # Preset options for command-line parsing.
  # @param [Symbol] presets are: `:minimal`, `:simple`, or `:server`.
  def self.preset_options(preset)
    case preset
    when :minimal
      Trollop.options do
        banner OPT_DESCS[:banner]
        opt :daemonize, OPT_DESCS[:daemonize]
        opt :pid, OPT_DESCS[:pid], type: :string
      end
    when :simple
      Trollop.options do
        banner OPT_DESCS[:banner]
        opt :daemonize, OPT_DESCS[:daemonize]
        opt :error, OPT_DESCS[:error], type: :string
        opt :group, OPT_DESCS[:group], type: :string
        opt :log, OPT_DESCS[:log], type: :string
        opt :pid, OPT_DESCS[:pid], type: :string
        opt :user, OPT_DESCS[:user], type: :string
        depends(:user, :group)
      end
    when :server
      Trollop.options do
        banner OPT_DESCS[:banner]
        opt :address, OPT_DESCS[:address], default: '0.0.0.0'
        opt :daemonize, OPT_DESCS[:daemonize]
        opt :error, OPT_DESCS[:error], type: :string
        opt :group, OPT_DESCS[:group], type: :string
        opt :log, OPT_DESCS[:log], type: :string
        opt :pid, OPT_DESCS[:pid], short: 'P', type: :string
        opt :port, OPT_DESCS[:port], default: 4567
        opt :user, OPT_DESCS[:user], type: :string
        depends(:user, :group)
      end
    else
      fail 'Invalid preset option.'
    end
  end

end