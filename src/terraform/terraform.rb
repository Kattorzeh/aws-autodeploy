require 'tools/log'
require 'tools/file_manager'
require 'open3'

class Terraform

    LOG_COMP = 'TERRAFORM'

    def prepare(params)
        Log.debug(LOG_COMP, 'Preparing terraform files')
    end
    
    # Execute Terraform init & plan 
    def init_plan(issue_number)
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

            Log.debug(LOG_COMP, "Terraform stdout:\n#{stdout}")
            unless status.success?
                Log.error(LOG_COMP, "Terraform plan command fails:\n#{stderr}")
                raise "Terraform plan command fails:\n#{stderr}"
            end
        end
    end    