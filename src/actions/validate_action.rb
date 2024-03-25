require 'actions/action'
require 'templates/validate_template'

class ValidateAction < Action
    attr_reader :success

    def execute(issue,issue_params)
        Log.info(LOG_COMP, "Validating template")
        validate_template = ValidateTemplate.new
        validate_template.validate(issue_params)
    end

    def report()
        Log.info(LOG_COMP, "Reporting Validation")
    end
end