require 'application/paths'

module Deploy
  class Application
    attr_reader :name, :root, :paths

    def exists?
      File.exists?(root)
    end

    def settings(force_update=false)
      file = paths.repo.join('.deploy.yml')
      @settings = nil if force_update
      @settings ||= YAML.load(file)
    end

  private

    def initialize(app_name)
      @name  = app_name.to_sym
      @root  = GLOBAL_ROOT.join(app_name.to_s)
      @paths = AppPaths.new(root)
    end

  end
end
