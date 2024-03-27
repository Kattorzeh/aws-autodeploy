require 'actions/action'
require 'terraform/terraform'

class DeployAction < Action
    attr_reader :success, :errors, :warnings

    def execute(issue_number,issue_params,services)
        Log.info(LOG_COMP, "Deploying template")

        begin
            Terraform.init_plan(issue_number)
            Terraform.apply(issue_number)
        rescue StandardError => e
            Log.error(LOG_COMP, "Deploying template failed: #{e}")
            @success = false
        else
            Log.info(LOG_COMP, "Template from Issue #{issue_number} deployed")
            @success = true
        end 

        return @success ? 'state-running' : 'state-failed-deploying'
    end

    def report()
        if @success
            "Deployment was successful!\n\n"
        else
            "Deployment failed\n\n"
        end
    end

end