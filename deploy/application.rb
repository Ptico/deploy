require 'application/paths'

module Deploy
  class Application
    attr_reader :name, :root, :paths

    def exists?
      File.exists?(root)
    end

    def config(force_update=false)
      file = paths.repo.join('.deploy.yml')
      @config = nil if force_update
      @config ||= YAML.load(file)
    end

    def recipes
      config['recipes'] || []
    end

    def listeners
      @events ||= begin

      listeners = Listenable.new

      config.keys.each do |key|
        if key.match(/^(on|before|after)_(\w+)/)
          listeners.send($1, $2, -> { Shell.run(config[key]) })
        end
      end

      listeners
    end

  private

    def initialize(app_name)
      @name  = app_name.to_sym
      @root  = GLOBAL_ROOT.join(app_name.to_s)
      @paths = AppPaths.new(root)
    end

  end
end
