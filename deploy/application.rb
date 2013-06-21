require 'json'
require 'deploy/application/paths'

module Deploy
  class Application
    attr_reader :name, :root, :paths

    def exists?
      File.exists?(root)
    end

    def config(force_update=false)
      file = paths.repo.join('deploy.json')
      @config = nil if force_update
      @config ||= (File.exists?(file) ? JSON.load(File.open(file)) : {}) || {}
    end

    def recipes
      config['recipes'] || []
    end

    def events
      config['events'] || {}
    end

    def listener
      @listener ||= begin
        listener = Listeners.new

        events.keys.each do |key|
          if key.match(/^(on|before|after)_(\w+)/)
            listener.send($1, $2, &->(app){ Shell.run(events[key]) })
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
