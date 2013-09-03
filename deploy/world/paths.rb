module Deploy
  class Paths
    attr_reader :root, :apps, :recipes

    def app(app_name)
      apps.join(app_name.to_s)
    end

  private

    def initialize(root_path)
      @root    = root_path
      @apps    = root_path.join('apps')
      @recipes = root_path.join('recipes')

      freeze
    end

  end
end