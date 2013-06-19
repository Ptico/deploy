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

    def events
      EVENTS[name]
    end

  private

    def initialize(app_name, command)
      @app  = Application.new(app_name)
      @name = command.to_sym
    end

  end
end
