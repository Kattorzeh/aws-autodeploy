require 'aws-sdk-ec2'
require_relative 'ec2_validator'

class ValidateTemplate
    LOG_COMP = 'VAL_TEMP'

    def initialize
        # AWS Clients
        Aws.config.update({
            credentials: Aws::Credentials.new(ENV['ACCESS_KEY_ID'], ENV['SECRET_ACCESS_KEY']),
            region: ENV['REGION']
        })
        @aws_ec2_client = Aws::EC2::Client.new
    end  

    def validate(params)
        errors = []

        params_to_validate = {
            ec2_instances: :validate_ec2_instances,
            ec2_name: :validate_ec2_name,
            ec2_instance_type: :validate_ec2_instance_type,
            ec2_ami_os: :validate_ec2_ami_os,
            ec2_ami: :validate_ec2_ami,
            ec2_tags: :validate_ec2_tags
        }

        params_to_validate.each do |param_key, validation_method|
            next unless params.key?(param_key)
      
            param_value = params[param_key].first
      
            errors.concat(EC2Validator.send(validation_method, param_value, @aws_ec2_client))
        end
        puts errors
        return errors  # Explicitly return errors
    end
    

    private

    def validate_ec2_instance_type(instance_type)
        EC2Validator.validate_ec2_instance_type(instance_type, @aws_ec2_client)
    end

    def validate_ec2_ami(ami_ids)
        EC2Validator.validate_ec2_ami(ami_ids, @aws_ec2_client)
    end

end
