require 'pathname'

module Deploy
  GLOBAL_ROOT = Pathname(__FILE__).dirname.realpath
end

$: << Deploy::GLOBAL_ROOT

require 'deploy/shell'
require 'deploy/listenable'
require 'deploy/listeners'
require 'deploy/application/paths'
require 'deploy/application'
require 'deploy/recipe'
require 'deploy/recipe_host'
require 'deploy/create'
require 'deploy/command'