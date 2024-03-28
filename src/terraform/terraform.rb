require 'tools/log'
require 'tools/file_manager'
require 'open3'
require 'erb'

class Terraform
    attr_reader :success

    LOG_COMP = 'TERRAFORM'

    
    def self.prepare(issue_number,order_params,services)
        Log.debug(LOG_COMP, 'Preparing terraform files')

        # Prepare AWS services terrform configs files
        errors = ""
        config_files = ""
        @success = true

        services.each do |service|
            config_file_path = File.join(TERRAFORM, "#{service.downcase}_config.tf")
    
            if File.exist?(config_file_path)
                config_files[service] = config_file_path
            else
                errors += "Configuration file #{config_file_path} for service #{service} not found.\n"
                @success = false
            end
        end

         # If there are no errors, call the FileManager method to commit the files
        if @success
            copied_files, errors = FileManager.commit_config_files(config_files, FileManager.DEPLOYMENT+'/'+issue_number)
        else
            Log.error(LOG_COMP, "Failed to prepare terraform files:\n#{errors}")
        end

        # Set AWS Provider Data
        template = Fiel.read(FileManager.AWS_PROVIDER)
        render = ERB.new(template)

        aws_region = ENV['AWS_REGION']
        aws_access_key = ENV['AWS_ACCESS_KEY']
        aws_secret_key = ENV['AWS_SECRET_KEY']

        result = renderer.result(binding)

        # Set variables from ordered_params in terraform config files
        

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