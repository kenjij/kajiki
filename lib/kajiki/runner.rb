require 'kajiki/handler'

module Kajiki

  class Runner

    include Handler

    # A wrapper to execute all commands.
    # @param opts [Hash] the command-line options.
    # @param block [Block] the command (String) will be passed.
    def self.run(opts, &block)
      opts[:auto_default_actions] = true
      runner = new(opts)
      runner.execute_command(&block)
    end

    # @param opts [Hash] the command-line options.
    def initialize(opts)
      @opts = opts
    end

    # Execute the command with the given block; usually called by ::run.
    def execute_command(cmd = ARGV, &block)
      cmd = validate_command(cmd)
      validate_options
      send(cmd, &block)
    end

    # Validate the given command.
    # @param cmd [Array] only one command should be given.
    # @return [String] extracts out of Array
    def validate_command(cmd = ARGV)
      fail 'Specify one action.' unless cmd.count == 1
      cmd = cmd.shift
      fail 'Invalid action.' unless SUB_COMMANDS.include?(cmd)
      cmd
    end

    # Validate the options; otherwise fails.
    def validate_options
      if @opts[:daemonize]
        fail 'Must specify PID file.' unless @opts[:pid_given]
      end
      @opts[:pid] = File.expand_path(@opts[:pid]) if @opts[:pid_given]
      @opts[:log] = File.expand_path(@opts[:log]) if @opts[:log_given]
      @opts[:error] = File.expand_path(@opts[:error]) if @opts[:error_given]
    end

    # Start the process with the given block.
    # @param [Block]
    def start(&block)
      fail 'No start block given.' if block.nil?
      check_existing_pid
      puts "Starting process..."
      Process.daemon if @opts[:daemonize]
      change_privileges if opts[:auto_default_actions]
      redirect_outputs if opts[:auto_default_actions]
      write_pid
      trap_default_signals if opts[:auto_default_actions]
      block.call('start')
    end

    # Stop the process.
    # @param [Block] will execute prior to shutdown, if given.
    def stop(&block)
      block.call('stop') unless block.nil?
      pid = read_pid
      fail 'No valid PID file.' unless pid && pid > 0
      Process.kill('TERM', pid)
      delete_pid
      puts 'Process terminated.'
    end

  end

end
