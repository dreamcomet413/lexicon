require "capistrano/setup"
require "capistrano/deploy"
require "capistrano/scm/git"
require 'capistrano/bundler'
require 'capistrano/rails'
require "capistrano/scm/git"
require 'capistrano/rvm'

install_plugin Capistrano::SCM::Git

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }

set :rvm_type, :user
set :rvm_ruby_version, '2.3.0p0'
