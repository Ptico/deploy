require 'deploy/listenable'
require 'deploy/shell'

module Deploy
  module Recipes
    class Recipe
      extend Listenable
      include Shell

      attr_reader :name, :app, :paths, :world, :options

      def self.default_options(opts=nil)
        if opts.is_a?(Hash)
          @default_options = Hashie::Mash.new(opts)
        else
          @default_options ||= Hashie::Mash.new
        end
      end

    private

      def initialize(app)
        @app     = app
        @paths   = app.paths
        @world   = Deploy.world
        @name    = self.class.name.split("::").last.downcase
        @options = get_options
      end

      def get_options
        app_opts = app.config.recipe_options ? app.config.recipe_options[name] : nil

        app_opts ? default_options.merge(app_opts) : default_options
      end

      def default_options
        self.class.default_options
      end

    end
  end
end
