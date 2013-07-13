require 'fileutils'

module Deploy
  class Command
    EVENTS = {
      deploy:  [:configure, :build, :migrate, :restart],
      update:  [:configure, :build]
    }

    COMMAND_LIST = EVENTS.keys

    UPDATERS = [:deploy, :update]

    attr_reader :app, :name, :logger

    def events
      @events ||= EVENTS[name] || [name]
    end

    def dispatch
      Bundler.with_clean_env do
        update if UPDATERS.include?(name)

        export_env

        listeners = recipe_listeners << app.listener

        events.each do |event|
          %W(before_#{event} on_#{event} after_#{event}).each do |event_name|
            listeners.each do |listener|
              listener.fire(event_name, app)
            end
          end
        end
      end
    end

  private

    def initialize(app_name, command, logger=Deploy.logger)
      @app     = Application.new(app_name)
      @recipes = RecipeHost.instance
      @name    = command.to_sym
      @logger  = logger
    end

    def app_recipes
      app.recipes
    end

    def recipe_listeners
      app_recipes.map do |recipe_name|
        @recipes.get(recipe_name)
      end
    end

    def update
      logger.info('Update repository')

      Shell::Command.new('git pull', { chdir: app.paths.repo })

      copy_release
      copy_shared
      link_current
    end

    def copy_release
      logger.info('Copy new release')

      # TODO - clean releases
      FileUtils.cp_r(app.paths.repo, app.paths.next_release)
    end

    def copy_shared
      Dir[app.paths.shared.join('*')].each do |file|
        FileUtils.cp_r(file, app.paths.current_release)
      end
    end

    def link_current
      logger.info('Link current release')

      FileUtils.rm_rf(app.paths.current)
      FileUtils.ln_s(app.paths.current_release, app.paths.current)
    end

    def export_env
      app_env = app.paths.root.join('Envfile')
      rel_env = app.paths.current.join('Envfile')

      files = []
      files << GLOBAL_ROOT.join('Envfile')
      files << app_env if File.exists?(app_env)
      files << rel_env if File.exists?(rel_env)

      Dotenv.load(*files)
    end

  end
end
