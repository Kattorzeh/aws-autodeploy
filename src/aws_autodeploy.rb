#!/usr/bin/env ruby
$LOAD_PATH << '../src'

require 'logger'
require 'tools/log'
require 'json'
require_relative 'actions/action'
require_relative 'tools/github_client'

# Global Objects:

# Logger
LOG_COMP = 'MAIN'

logger = Logger.new(STDOUT)
Log.logger = logger
Log.info(LOG_COMP, 'Starting AWS-Autodeploy')

# Action tag
action_tag = ARGV[0].to_s
Log.debug(LOG_COMP, "Action tag: #{action_tag}")

# Issue from GItHUb Client
issue_number = ARGV[1]
issue = Github.get_issue(issue_number)

Log.info(LOG_COMP, "issue: #{issue}")

# Code:

# Generate action from issue tag
action = Action.for(action_tag)

# Execute action
Log.debug(LOG_COMP, "Executing action '#{action_tag}'")
action.execute(issue)

# Report results
Log.debug(LOG_COMP, "Reporting action '#{action_tag}'")
action.report()
