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

    def dispatch
      listeners = recipe_listeners << app.listener

      events.each do |event|
        %W(before_#{event} on_#{event} after_#{event}).each do |event_name|
          listeners.each do |listener|
            listener.fire(event_name, app)
          end
        end
      end
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

    def recipe_listeners
      app_recipes.map do |recipe_name|
        @recipes.get(recipe_name)
      end
    end

  end
end
