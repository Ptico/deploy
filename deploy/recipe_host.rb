require 'singleton'
require 'inflecto'

module Deploy
  class RecipeHost
    include Singleton

    attr_reader :index, :cache

    PATTERN = GLOBAL_ROOT.join('recipes/*/*.rb')

    def filelist
      Dir[PATTERN]
    end

    def get(recipe_name)
      name = recipe_name.to_sym

      load(name) unless cache.has_key?(name)

      cache[name]
    end

  private

    def initialize
      @index = {}
      @cache = {}

      build_index
    end

    def build_index
      filelist.each do |file|
        index[File.basename(file, '.rb').to_sym] = file
      end
    end

    def load(recipe_name)
      name = recipe_name.to_sym

      Kernel.require(index[name])

      cache[name] = constantize(name.to_s)
    end

    # TODO - use mbj/inflecto instead
    def constantize(name)
      camel = Inflecto.camelize(name)
      Inflecto.constantize("Deploy::Recipes::#{camel}")
    end
  end
end
