module Deploy
  module Recipes
    class ActiveRecord < Recipe
      on :configure do
        run 'cp shared/database.yml current/config/database.yml'
      end

      on :migrate do
        run 'bundle exec rake db:create'
        run 'bundle exec rake db:migrate'
      end
    end
  end
end
