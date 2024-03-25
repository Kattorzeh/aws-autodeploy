require 'json-schema'
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
         # Convert params to symbol keys
        params = params.transform_keys(&:to_sym)

        # Validate against EC2 schema
        errors = JSON::Validator.fully_validate(EC2Validator::EC2_SCHEMA, params)
        
        # Validate EC2 instance type
        errors += EC2Validator.validate_ec2_instance_type(params[:ec2_instance_type], @aws_ec2_client)

        # Validate EC2 AMI
        errors += EC2Validator.validate_ec2_ami(params[:ec2_ami], @aws_ec2_client)

        # Prepare error messages
        error_messages = errors.empty? ? "No errors found." : "Errors found:\n#{errors.join("\n")}"
        puts error_messages
    end
    
end
