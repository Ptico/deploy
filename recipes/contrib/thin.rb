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
            run "bundle exec thin #{options} restart"
          else
            start
          end
        end
      end

      def start
        chdir paths.current_release do
          run "bundle exec thin #{options} start"
        end
      end

      def options
        opts = []
        opts << "--socket " + (config['socket'] || paths.shared.join('tmp/sockets/thin.sock').to_s)
        opts << "--rackup #{config['rackup']}" if config['rackup']
        opts << "--environment " + (config['environment'] || ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'production')
        opts << "--log " + (config['logfile'] || paths.shared.join('log/thin.log').to_s)
        opts << "--pid " + pidfile
        opts << "--daemonize"
        opts.join(' ')
      end

      def config
        app.config['thin'] || {}
      end

      def pidfile
        config['pidfile'] || paths.shared.join('tmp/pids/thin.pid').to_s
      end
    end
  end
end