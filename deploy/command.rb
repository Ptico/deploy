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
      @events ||= EVENTS[name]
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

    def build_listeners
      listeners = app_recipes.each_with_object({}) do |recipe_name, listeners|
        recipe = @recipes.get(recipe_name)
        add_listener(recipe)
      end

      app.listeners.each do |listenable|
        add_listener(listenable)
      end
    end

    def add_listener(listenable)
      listenable.events.each do |event|
        if events.include?(event)
          listeners[event] = listenable
        end
      end
    end

  end
end
