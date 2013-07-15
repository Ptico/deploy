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

      def initialize(command_str, options={}, logger=Deploy.logger)
        @command = command_str.to_s.strip
        @options = options
        @logger  = logger
        execute
      end

      def execute
        logger.info("Run #{command}")

        begin
          @stdin, @stdout, @stderr, @wait_thread = Open3.popen3(@command, @options)
        rescue Errno::ENOENT => e
          logger.fatal(e.message) and return
        end

        @output = if status > 0
          logger.error(error)
          logger.info(value)
          error
        else
          logger.info(value)
          value
        end
      end

    end

  end
end