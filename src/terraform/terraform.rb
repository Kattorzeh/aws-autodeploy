require 'tools/log'
require 'tools/file_manager'
require 'open3'

class Terraform

    LOG_COMP = 'TERRAFORM'

    def self.prepare(issue_number)
        Log.debug(LOG_COMP, 'Preparing terraform files')
    end

    # Execute Terraform init & plan 
    def self.init_plan(issue_number)
        FileManager.change_dir_temp(FileManager.DEPLOYMENT+'/'+issue_number) do
            # Terraform init
            Log.debug(LOG_COMP, 'Running terraform init')

            stdout, stderr, status = Open3.capture3('terraform init') 
            unless status.success?
                Log.error(LOG_COMP, "Terraform init command fails:\n#{stderr}")
                raise "Terraform init command fails:\n#{stderr}"
            end

            # Terraform plan -> for validate configuration
            Log.debug(LOG_COMP, 'Running terraform iniplant')
            
            stdout, stderr, status = Open3.capture3(
                'bash -c "set -o pipefail; ' <<
                'terraform plan -out=./plan.txt; ' <<
                'terraform show -json ./plan.txt"'
            )

            Log.debug(LOG_COMP, "Terraform plan stdout:\n#{stdout}")
            unless status.success?
                Log.error(LOG_COMP, "Terraform plan command fails:\n#{stderr}")
                raise "Terraform plan command fails:\n#{stderr}"
            end
        end
    end

    # Execute Terraform apply operation
    def self.apply(issue_number)
        FileManager.change_dir_temp(FileManager.DEPLOYMENT+'/'+issue_number) do
            # Terraform init
            stdout, stderr, status = Open3.capture3('terraform apply')
            unless status.success?
                Log.error(LOG_COMP, "Terraform init command fails:\n#{stderr}")
                raise "Terraform init command fails:\n#{stderr}"
            end

            # Terraform apply
            Log.debug(LOG_COMP, "Running terraform apply")

            stdout, stderr, status = Open3.capture3('terraform apply -auto-approve -no-color') 
            
            Log.debug(LOG_COMP, "Terraform apply stdout:\n#{stdout}")
            unless status.success?
                Log.error(LOG_COMP, "Terraform apply command fails:\n#{stderr}")
                raise "Terraform apply command fails:\n#{stderr}"
            end

            # Use Terraform-bin version for better JSON parsing
            Log.debug(LOG_COMP, "Parsing terraform information")
            stdout, _stderr, _status = Open3.capture3('terraform-bin output -json -no-color')

            outputs = JSON.parse(stdout)
            puts outputs
        end
    end
end