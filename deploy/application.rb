require 'yaml'
require 'deploy/application/paths'

module Deploy
  class Application
    attr_reader :name, :root, :paths

    def exists?
      File.exists?(root)
    end

    def config(force_update=false)
      file = paths.repo.join('deploy.yml')
      @config = nil if force_update
      @config ||= (File.exists?(file) ? YAML.load_file(file.to_s) : {}) || {}
    end

    def recipes
      config['recipes'] || []
    end

    def listener
      @listener ||= begin
        listener = Listeners.new

        config.keys.each do |key|
          if key.match(/^(on|before|after)_(\w+)/)
            listener.send($1, $2, &->(app){ Shell.run(config[key]) })
          end
        end

        listener
      end
    end

  private

    def initialize(app_name)
      @name  = app_name.to_sym
      @root  = GLOBAL_ROOT.join('apps', app_name.to_s)
      @paths = Paths.new(root)
    end

  end
end
