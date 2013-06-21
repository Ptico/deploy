require 'pathname'

module Deploy
  GLOBAL_ROOT = Pathname(__FILE__).dirname.realpath
end

require 'deploy/shell'
require 'deploy/listenable'
require 'deploy/listeners'
require 'deploy/application/paths'
require 'deploy/application'
require 'deploy/recipe'
require 'deploy/recipes'
require 'deploy/command'