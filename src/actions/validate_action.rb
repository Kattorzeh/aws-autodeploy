require 'actions/action'
require 'templates/validate_template'
require 'templates/ec2_validator'

class ValidateAction < Action
    attr_reader :success

    def execute(issue,issue_params)
        Log.info(LOG_COMP, "Validating template")
        validate_template = ValidateTemplate.new
        puts issue_params
        errors = validate_template.validate(issue_params)
        puts errors.inspect
    end

    def report()
        Log.info(LOG_COMP, "Reporting Validation")
    end
end