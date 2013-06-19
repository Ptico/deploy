module Deploy
  class Command
    EVENTS = {
      deploy:  [:configure, :build, :migrate, :restart],
      update:  [:configure, :build],
      migrate: [:migrate],
      start:   [:start],
      stop:    [:stop],
      restart: [:restart]
    }

    COMMAND_LIST = EVENTS.keys

    UPDATERS = [:deploy, :update]

    attr_reader :app, :name

    def events
      EVENTS[name]
    end

  private

    def initialize(app_name, command)
      @app     = Application.new(app_name)
      @recipes = Recipes.instance
      @name    = command.to_sym
    end

    def app_recipes
      app.recipes
    end

    def dispatch
      recipes = app_recipes.map do |recipe_name|
        @recipes.get(recipe_name)
      end
    end

  end
end
