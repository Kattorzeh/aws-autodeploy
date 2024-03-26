require 'actions/action'
require 'templates/validate_template'

class ValidateAction < Action
    attr_reader :success, :errors, :warnings

    def execute(issue,issue_params)
        Log.info(LOG_COMP, "Validating template")

        validate_template = ValidateTemplate.new
        @errors, @warnings = validate_template.validate(issue_params)
        
        if @errors.empty?
            @success = true
            Log.debug(LOG_COMP, "Validation was successful")
        else
            @success = false
            Log.error(LOG_COMP, "Validation failed with errors: #{@errors}")
        end
        return @success ? 'VALIDATED' : 'FAILED_VALIDATE'
    end

    def report()
        if @success
            warnings_formatted = @warnings.map { |warning| "* Warning: #{warning}" }.join("\n")
            "Validation was successful!\n\n#{warnings_formatted}"
        else
            errors_formatted = @errors.map { |error| "* Error: #{error}" }.join("\n")
            "Validation failed with the following errors:\n\n#{errors_formatted}"
        end
    end
end