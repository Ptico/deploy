module Deploy
  module Recipes
    class ActiveRecord < Recipe
      on :preconfigure do
        chdir paths.current do
          run 'bundle exec rake db:create'
        end
      end

      on :configure do
        run 'cp shared/database.yml current/config/database.yml'
      end

      on :migrate do
        run 'bundle exec rake db:migrate'
      end
    end
  end
end
