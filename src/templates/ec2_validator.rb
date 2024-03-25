require 'aws-sdk-ec2'
require_relative 'validate_template'

module EC2ValidatorMethods
  def validate_ec2_instance_type(instance_type, aws_ec2_client)
    errors = []
    if instance_type.nil?
      errors << "EC2 instance type is not specified."
    else
      response_type = aws_ec2_client.describe_instance_type_offerings(
        filters: [{ name: 'instance-type', values: [instance_type] }]
      )
      if response_type.instance_type_offerings.empty?
        errors << "The instance type '#{instance_type}' is not valid."
      end
    end
    errors
  end

  def validate_ec2_ami(ami_id, aws_ec2_client)
    errors = []
    if ami_id.nil?
      errors << "EC2 AMI is not specified."
    else
      begin
        response_bad_ami = aws_ec2_client.describe_images(image_ids: [ami_id])
      rescue Aws::EC2::Errors::InvalidAMIIDNotFound => e
        errors << "AMI '#{ami_id}' not found."
      end
    end
    errors
  end
end

class EC2Validator < ValidateTemplate
  include EC2ValidatorMethods

  def initialize
    super
  end

  def validate(params)
    errors = super
    errors.each { |error| puts error }
    errors
  end
end