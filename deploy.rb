$: << Pathname(__FILE__).dirname.realpath.to_s

require 'pathname'
require 'bundler/setup'

require 'lumberjack'
require 'inflecto'
require 'dotenv'
require 'hashie/mash'

module Deploy
  class << self
    def logger
      @logger ||= Lumberjack::Logger.new(STDOUT)
    end

    def world
      @world ||= World.new(Pathname(Dir.pwd))
    end
  end
end

require 'deploy/world'
require 'deploy/shell'
require 'deploy/listenable'
require 'deploy/listeners'
require 'deploy/application/paths'
require 'deploy/application'
require 'deploy/recipe'
require 'deploy/recipe_host'
require 'deploy/create'
require 'deploy/command'