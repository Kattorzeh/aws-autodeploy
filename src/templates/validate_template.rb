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

        params.each do |key, values|  # Use `values` for arrays
          values.each do |value|
            validation_method = "validate_ec2_#{key}"
            if EC2Validator.respond_to?(validation_method)  # Check for method existence
              errors += EC2Validator.send(validation_method, value, @aws_ec2_client)
            else
              errors << "Validation method for key '#{key}' not found."
            end
          end
        end
    
        puts errors  # Optional for debugging
        errors
    end

end
