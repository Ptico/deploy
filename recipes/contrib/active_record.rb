module Deploy
  module Recipes
    class ActiveRecord < Recipe
      on :configure do
        FileUtils.cp(paths.shared.join('database.yml'), paths.current_release.join('config'))
      end

      on :migrate do
        chdir paths.current_release do
          run 'bundle exec rake db:create'
          run 'bundle exec rake db:migrate'
        end
      end
    end
  end
end
