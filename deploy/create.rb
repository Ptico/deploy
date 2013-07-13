require 'fileutils'

module Deploy
  class Create
    attr_reader :name, :repo, :app, :logger

    def dispatch
      return if app.exists? # TODO - exception

      create_folders
      clone_repo
      create_files
      copy_release

      Command.new(name, :preconfigure).dispatch
    end

  private

    def initialize(app_name, git_repo, logger=Deploy.logger)
      @name = app_name.to_s
      @repo = git_repo.to_s

      @app = Application.new(app_name)

      @logger = logger
    end

    def create_folders
      logger.info('Create app folders')

      app.paths.each do |path|
        FileUtils.mkdir_p(path) # TODO - do not create current
      end
    end

    def clone_repo
      logger.info('Clone repository')

      Shell::Command.new("git clone #{repo} #{app.paths.repo}")
    end

    def create_files
      logger.info('Create app files')

      File.open(app.root.join('Envfile'), File::WRONLY|File::CREAT) do |f|
        f.write('APP_ROOT=' + app.root.to_s) # TODO - another paths, template
      end
    end

    def copy_release
      logger.info('Copy first release')

      FileUtils.cp_r(app.paths.repo, app.paths.next_release)
    end

  end
end
