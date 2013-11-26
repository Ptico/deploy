module Deploy
  module Recipes
    class Thin < Recipe
      on :start, :start

      on :stop do
        chdir paths.current_release do
          run "bundle exec thin --pid #{pidfile} stop"
        end
      end

      on :restart do
        chdir paths.current_release do
          if File.exists?(pidfile)
            run "bundle exec thin #{arguments} restart"
          else
            start
          end
        end
      end

      on :configure do
        create_folders
      end

      def start
        chdir paths.current_release do
          run "bundle exec thin #{arguments} start"
        end
      end

      def arguments
        args = []
        args << "--chdir " + paths.current_release.to_s
        args << "--socket " + (options.socket || paths.shared.join('tmp/sockets/thin.sock').to_s)
        args << "--rackup #{options.rackup}" if options.rackup?
        args << "--environment " + (options.environment || ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'production')
        args << "--log " + (options.logfile || paths.shared.join('log/thin.log').to_s)
        args << "--pid " + pidfile
        args << "--daemonize"
        args.join(' ')
      end

      def pidfile
        options.pidfile || paths.shared.join('tmp/pids/thin.pid').to_s
      end

      def create_folders
        folders = [
          paths.shared.join('tmp/sockets'),
          paths.shared.join('tmp/pids'),
        ]
        FileUtils.mkdir_p folders
      end
    end
  end
end