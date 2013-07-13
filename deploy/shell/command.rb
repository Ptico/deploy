require 'open3'
require 'logger'

module Deploy
  module Shell

    class Command

      attr_reader :output

      def value
        @value ||= stdout.read
      end

      def error
        @error ||= stderr.read
      end

      def status
        @status ||= wait_thread.value.exitstatus
      end

    private

      attr_reader :command, :logger, :stdin, :stdout, :stderr, :wait_thread

      def initialize(command_str, options={}, logger=Logger)
        @command = command_str.to_s.strip
        @options = options
        @logger = Logger.new(STDOUT)
        execute
      end

      def execute
        logger.info("Running #{command}")

        begin
          @stdin, @stdout, @stderr, @wait_thread = Open3.popen3(@command, @options)
        rescue Errno::ENOENT => e
          logger.fatal(e.message) and return
        end

        @output = if status > 0
          logger.error(error)
          error
        else
          logger.info(value)
          value
        end
      end

    end

  end
end