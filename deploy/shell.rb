require 'deploy/shell/command'

module Deploy
  module Shell

    def run(command, options={})
      Command.new(command, options)
    end

    def chdir(dir, &block)
      Dir.chdir(dir) do
        block.yield
      end
    end

  end
end
