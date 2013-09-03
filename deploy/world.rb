require 'deploy/world/paths'

module Deploy
  class World

    attr_reader :root, :paths

    def apps
      Pathname.glob(paths.apps.join('*/')).map{ |dir| dir.basename.to_s.to_sym }
    end

  private

    def initialize(root_path)
      @root  = root_path
      @paths = Paths.new(root)
    end
  end
end