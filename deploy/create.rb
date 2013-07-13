require 'fileutils'

module Deploy
  class Create
    attr_reader :name, :repo, :app

    def dispatch
      return if app.exists? # TODO - exception

      create_folders
      clone_repo
      create_files

      Command.new(name, :preconfigure).dispatch
    end

  private

    def initialize(app_name, git_repo)
      @name = app_name.to_s
      @repo = git_repo.to_s

      @app = Application.new(app_name)
    end

    def create_folders
      app.paths.each do |path|
        FileUtils.mkdir_p(path) # TODO - do not create current
      end
    end

    def clone_repo
      %x(git clone #{repo} #{app.paths.repo})
    end

    def create_files
      File.open(app.root.join('Envfile'), File::WRONLY|File::CREAT) do |f|
        f.write('APP_ROOT=' + app.root.to_s) # TODO - another paths, template
      end
    end

  end
end
