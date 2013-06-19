require 'fileutils'

module Deploy
  class Setup
    attr_reader :name, :repo, :app

    def create_folders
      app.paths.each do |path|
        FileUtils.mkdir_p(path) # TODO - do not create current
      end
    end

    def clone_repo
      %x(git clone #{repo} #{repo_path})
    end

    def create_files
      File.open(app.root.join('Envfile'), File::WRONLY) do |f|
        f.write('APP_ROOT=' + app.root.to_s) # TODO - another paths, template
      end
    end

  private

    def initialize(app_name, git_repo)
      @name = app_name.to_s
      @repo = git_repo.to_s

      @app = Application.new(app_name)

      return if app.exists? # TODO - exception

      create_folders
      clone_repo
      create_files
    end

  end
end
