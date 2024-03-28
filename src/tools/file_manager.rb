require 'tools/log'
require 'fileutils'

class FileManager
    attr_reader :success

    LOG_COMP = 'FM'

    # Global relative PATHS
    DEPLOYMENT      = '../../deployments'
    TERRAFORM       = '../terraform'
    AWS_PROVIDER    = './aws_provider.rf.erb'
    
    # Temporarily changes the current directory to `dir`, executes the block, and reverts the directory back.
    def self.change_dir_temp(dir)
        begin
            pwd = Dir.pwd
            Dir.chdir dir
            yield
        ensure
            Dir.chdir pwd
        end
    end

    # Copies Terraform configuration files for the specified services to a new folder within 'deployments'
    def self.commit_config_files(config_files, deploy_path)
        errors = ""
        copied_files = ""
        @success = true

        config_files.each do |service, config_file_path|
            deployment_dir = File.join(deploy_path, service.downcase)
            FileUtils.mkdir_p(deployment_dir)

            begin
                FileUtils.cp(config_file_path, deployment_dir)
                copied_files += "#{deployment_dir}/#{config_file_path};"
            rescue => e
                errors += "Error copying #{config_file_path}: #{e.message}\n"
                @success = false
            end
        end

        if !@success
            Log.error(LOG_COMP, "Failed to copy terraform configuration files:\n#{errors}")
        end

        return copied_files, errors
    end 

    def self.
    def self.create_dir(name)

    end   
end