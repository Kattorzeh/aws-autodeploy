#!/usr/bin/env ruby
$LOAD_PATH << '../src'

require 'logger'
require 'tools/log'
require 'json'
require 'octokit'
require_relative 'actions/action'
require_relative 'tools/github_client'
require_relative 'tools/issue_params'
require_relative 'templates/validate_template'

# Global Objects:

# Logger
LOG_COMP = 'MAIN'

logger = Logger.new(STDOUT)
Log.logger = logger
Log.info(LOG_COMP, 'Starting AWS-Autodeploy')

# Client for issue comments & labels
client = Octokit::Client.new(access_token: ENV['GH_TOKEN'])

# Action tag
action_tag = ARGV[0].to_s
Log.debug(LOG_COMP, "Action tag: #{action_tag}")

# Issue from GitHub Client
repo = ENV['GITHUB_REPOSITORY']
issue_number = ARGV[1]
issue = Github_client.get_issue(issue_number)
Log.debug(LOG_COMP, "Issue num: #{issue_number}")

# Get Params from Issue
parameterizer = IssueParams.new(issue['body'])
issue_params = parameterizer.get_params()
accepted_services = ["ec2", "s3"]
services = parameterizer.get_services(issue_params,accepted_services)
ordered_params = parameterizer.get_order_params(issue_params,services)
# Code:

# Generate action from issue tag
action = Action.for(action_tag)

# Execute action
Log.debug(LOG_COMP, "Executing action '#{action_tag}'")
action_state=action.execute(issue_number,ordered_params,services)

# Report results
Log.debug(LOG_COMP, "Reporting action '#{action_tag}'")
comment_body = action.report()
client.add_comment(repo, issue_number, comment_body)


# Update Issue States
Log.debug(LOG_COMP, "Updating labels for Issue")
client.replace_all_labels(repo, issue_number, [action_state])