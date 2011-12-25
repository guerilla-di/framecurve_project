require 'serve'
require 'serve/rack'

require 'sass/plugin/rack'
require 'compass'

# The project root directory
root = ::File.dirname(__FILE__)

# Compass
Compass.add_project_configuration(root + '/compass.config')
Compass.configure_sass_plugin!

# Middleware
use Rack::ShowStatus      # Nice looking 404s and other messages
use Rack::ShowExceptions  # Nice looking errors
use Sass::Plugin::Rack    # Compile Sass on the fly

# We use Rack::Cascade and Rack::Directory on other platforms to
# handle static assets
run Rack::Cascade.new([
  Serve::RackAdapter.new(root),
  Rack::Directory.new(root)
])