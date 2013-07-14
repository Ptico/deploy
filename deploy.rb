require 'pathname'
require 'bundler/setup'

require 'lumberjack'
require 'inflecto'
require 'dotenv'

module Deploy
  GLOBAL_ROOT = Pathname(__FILE__).dirname.realpath

  class << self
    def logger
      @logger ||= Lumberjack::Logger.new(STDOUT)
    end
  end
end

$: << Deploy::GLOBAL_ROOT.to_s

require 'deploy/shell'
require 'deploy/listenable'
require 'deploy/listeners'
require 'deploy/application/paths'
require 'deploy/application'
require 'deploy/recipe'
require 'deploy/recipe_host'
require 'deploy/create'
require 'deploy/command'