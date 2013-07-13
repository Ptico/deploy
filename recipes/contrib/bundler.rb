module Deploy
  module Recipes
    class Bundler < Recipe
      before :preconfigure do
        chdir paths.current_release do
          run 'bundle install'
        end
      end

      before :configure do
        chdir paths.current_release do
          run "bundle install --deployment --binstubs bin/ --without development:test --path #{paths.shared.join('vendor/bundle')} --gemfile #{paths.current_release.join('Gemfile')}"
        end
      end
    end
  end
end
