module Deploy
  module Recipes
    class Bundler < Recipe
      before :preconfigure do
        chdir paths.current do
          run 'bundle install'
        end
        
      end

      before :configure do
        chdir paths.current do
          run 'bundle install'
        end
      end
    end
  end
end
