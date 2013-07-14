module Deploy
  module Recipes
    class ActiveRecord < Recipe
      on :migrate do
        chdir paths.current_release do
          run 'bundle exec rake db:create'
          run 'bundle exec rake db:migrate'
        end
      end
    end
  end
end
