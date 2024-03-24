require 'actions/action'

class ValidateAction < Action
    attr_reader :success

    def execute(issue,issue_params)
        Log.info(LOG_COMP, "Validating template")
        Log.info(LOG_COMP, "Issue Params: #{issue_params}")
        puts "Params:"
        issue_params.each do |param, value|
            puts "#{param}: #{value.inspect}"
        end
    end

    def report()
        Log.info(LOG_COMP, "Reporting Validation")
    end
end