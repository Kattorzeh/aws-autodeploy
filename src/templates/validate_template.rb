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
        Log.info(LOG_COMP, "Validating params with EC2 Schema")

        # Validate EC2 Schema
        params.each do |key, value|
            Log.debug(LOG_COMP, "Validating #{key} with EC2 Schema")
            if value.is_a?(Array)
              value.each do |v|
                validate_single_param(key, v, errors)
              end
            else
              validate_single_param(key, value, errors)
            end
        end

        # Validate EC2 type & ami
        if params['ec2_instance_type'].is_a?(Array)
            params['ec2_instance_type'].each do |instance_type|
              errors.concat(EC2Validator.validate_ec2_instance_type(instance_type, aws_ec2_client))
            end
        elsif params['ec2_instance_type']
            errors.concat(EC2Validator.validate_ec2_instance_type(params['ec2_instance_type'], aws_ec2_client))
        end
        
        if params['ec2_ami'].is_a?(Array)
            params['ec2_ami'].each do |ami|
              errors.concat(EC2Validator.validate_ec2_ami(ami, aws_ec2_client))
            end
        elsif params['ec2_ami']
            errors.concat(EC2Validator.validate_ec2_ami(params['ec2_ami'], aws_ec2_client))
        end

        # EC2 Schema Validation Result
        if errors.empty?
            Log.info(LOG_COMP, "EC2 params were validated with EC2 Schema")
        else
            Log.info(LOG_COMP, "EC2 params were NOT validated with EC2 Schema")
            Log.debug(LOG_COMP, "Error: #{errors.join("\n")}")
        end
    end
    
    def validate_single_param(key, value, errors)
        begin
          JSON::Validator.validate!({ key => EC2Validator::EC2_SCHEMA[:properties][key] }, { key => value })
        rescue JSON::Schema::ValidationError => e
          errors << e.message
        end
    end  
end
