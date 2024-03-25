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
        aws_ec2_client = Aws::EC2::Client.new
    end  

    def validate(params)
        errors = []

        # Validate EC2 Schema
        begin
            Log.info(LOG_COMP, "Validating params with EC2 Schema")
            JSON::Validator.validate!(EC2Validator::EC2_SCHEMA, params)
        rescue JSON::Schema::ValidationError => e
            errors << e.message
        end

        # Validate EC2 type & ami
        errors.concat(EC2Validator.validate_ec2_instance_type(params['ec2_instance_type'])) if params['ec2_instance_type']
        errors.concat(EC2Validator.validate_ec2_ami(params['ec2_ami'])) if params['ec2_ami']


        # EC2 Schema Validation Result
        if errors.empty?
            Log.info(LOG_COMP, "EC2 params were validated with EC2 Schema")
        else
            Log.info(LOG_COMP, "EC2 params were NOT validated with EC2 Schema")
            Log.debug(LOG_COMP, "Error: #{errors.join("\n")}")
        end
    end  
end
