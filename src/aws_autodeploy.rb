#!/usr/bin/env ruby
$LOAD_PATH << '../src'

require 'logger'
require 'tools/log'
require_relative 'actions/action'
require 'json'
require 'octokit'

# Global Objects:

# Logger
LOG_COMP = 'MAIN'

logger = Logger.new(STDOUT)
Log.logger = logger
Log.info(LOG_COMP, 'Starting AWS-Autodeploy')

# Action tag
action_tag = ARGV[0].to_s
Log.debug(LOG_COMP, "Action tag: #{action_tag}")

# Issue from JSON
issue_json = ARGV[0]
issue = JSON.parse(issue_json)

# Code:

# Generate action from issue tag
action = Action.for(action_tag)

# Execute action
Log.debug(LOG_COMP, "Executing action '#{action_tag}'")
action.execute(issue)

# Report results
Log.debug(LOG_COMP, "Reporting action '#{action_tag}'")
action.report()

# Add description field in the Issue
client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
client.add_comment(ENV['GITHUB_REPOSITORY'], ENV['GITHUB_EVENT_NUMBER'], "Esto es un ejemplo de comentario desde el script aws_autodeploy.rb")
