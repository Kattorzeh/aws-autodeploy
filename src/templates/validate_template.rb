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
        params.each do |key, value|
            puts key
            if value.is_a?(Array)
                value.each do |item|
                    errors += send("validate_#{key}", item) if respond_to?("validate_#{key}")
                end
            else
                errors += send("validate_#{key}", value) if respond_to?("validate_#{key}")
            end
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
