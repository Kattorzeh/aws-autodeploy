require 'aws-sdk-ec2'
require_relative 'ec2_validator'

class ValidateTemplate
  LOG_COMP = 'VAL_TEMP'

  validations = {
    :ec2_instances => :validate_ec2_instances,
    :ec2_name => :validate_ec2_name,
    :ec2_instance_type => nil, 
    :ec2_ami_os => :validate_ec2_ami_os,
    :ec2_ami => nil, 
    :ec2_tags => :validate_ec2_tags
  }
  def initialize
    Aws.config.update({
      credentials: Aws::Credentials.new(ENV['ACCESS_KEY_ID'], ENV['SECRET_ACCESS_KEY']),
      region: ENV['REGION']
    })
    @aws_ec2_client = Aws::EC2::Client.new
  end

  def validate(params)
    errors = []
    params.each do |key, values|
      validation_method = validations[key]
      if validation_method
        values.each do |value|
          puts "Validation for #{key}: #{Validators.send(validation_method, value)}"
        end
      else
        puts "No validation for #{key}"
      end
    end
  end
end

  
