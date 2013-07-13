require 'deploy/listenable'
require 'deploy/shell'

module Deploy
  module Recipes
    class Recipe
      extend Listenable
      include Shell

      attr_reader :app, :paths

    private

      def initialize(app)
        @app   = app
        @paths = app.paths
      end

    end
  end
end
