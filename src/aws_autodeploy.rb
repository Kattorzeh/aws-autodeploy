#!/usr/bin/env ruby
$LOAD_PATH << '../src'

require 'logger'
require 'tools/log'
require_relative 'actions/action'
require 'octokit'

# Global Objects

# Logger
LOG_COMP = 'MAIN'

logger = Logger.new(STDOUT)
Log.logger = logger
Log.info(LOG_COMP, 'Starting AWS-Autodeploy')

# Action tag
action_tag = ARGV[0].to_s
Log.debug(LOG_COMP, "Action tag: #{action_tag}")

# Code:

# Generate action from issue
action = Action.for(action_tag)

# Execute action
Log.debug(LOG_COMP, "Executing action '#{action_tag}'")
action.execute()

# Report results
Log.debug(LOG_COMP, "Reporting action '#{action_tag}'")
action.report()

# Add description field in the Issue

# Crear un cliente Octokit usando el token de acceso de GitHub Actions
client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])

# Agregar un comentario a la issue actual
client.add_comment(ENV['GITHUB_REPOSITORY'], ENV['GITHUB_EVENT_NUMBER'], "Esto es un ejemplo de comentario desde el script aws_autodeploy.rb")
