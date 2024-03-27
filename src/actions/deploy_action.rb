require 'actions/action'

class DeployAction < Action
    attr_reader :success, :errors, :warnings

    def execute(issue,issue_params)
        Log.info(LOG_COMP, "Deploying template")
        
        #validate_template = ValidateTemplate.new
        #@errors, @warnings = validate_template.validate(issue_params)
        
        if @errors.empty?
            @success = true
            Log.info(LOG_COMP, "Deployment was successful")
        else
            @success = false
            Log.error(LOG_COMP, "Deployment failed with errors: #{@errors}")
        end
        return @success ? 'state-validated' : 'state-failed-validate'
    end

    def report()
        if @success
            warnings_formatted = @warnings.map { |warning| "* Warning: #{warning}" }.join("\n")
            "Deployment was successful!\n\n#{warnings_formatted}"
        else
            errors_formatted = @errors.map { |error| "* Error: #{error}" }.join("\n")
            "Deployment failed with the following errors:\n\n#{errors_formatted}"
        end
    end

end