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
            errors.concat(send("validate_#{key}", value)) if respond_to?("validate_#{key}")
        end
        puts errors
        errors
    end
    

    private

    def validate_ec2_instance_type(instance_type)
        EC2Validator.validate_ec2_instance_type(instance_type, @aws_ec2_client)
    end

    def validate_ec2_ami(ami_ids)
        EC2Validator.validate_ec2_ami(ami_ids, @aws_ec2_client)
    end

end
