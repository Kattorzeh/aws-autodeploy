#!/usr/bin/env ruby
$LOAD_PATH << '../src'

require 'logger'
require 'tools/log'


# Global Objects
# Logger
LOG_COMP = 'MAIN'

logger = Logger.new(STDOUT)
Log.logger = logger
Log.level  = 3
Log.info(LOG_COMP, 'Starting AWS-Autodeploy')

# Action tag
action_tag = ARGV[0].to_s



# Code:

# Generate action from issue
action = Action.for(action_tag)

# Execute action
Log.debug(LOG_COMP, "Executing action '#{action_tag}'")
action.execute(self)

# Report results
Log.debug(LOG_COMP, "Reporting action '#{action_tag}'")
action.report(self)