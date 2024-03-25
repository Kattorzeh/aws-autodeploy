require 'aws-sdk-ec2'
require_relative 'validate_template'

module EC2ValidatorMethods

    def initialize
        super
    end

    def validate_ec2_instances(values)
      validate_numerical_values(values, "ec2_instances")
    end
  
    def validate_ec2_name(values)
      validate_strings(values, "ec2_name")
    end
  
    def validate_ec2_ami_os(values)
      validate_ami_os(values, "ec2_ami_os")
    end
  
    def validate_ec2_tags(values)
      validate_strings(values, "ec2_tags")
    end

    def self.validate_ec2_instance_type(instance_type, aws_ec2_client)
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
    
    def self.validate_ec2_ami(ami_id, aws_ec2_client)
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
  
    private
  
    def validate_strings(values, key)
      values.map { |value| "Invalid #{key}: #{value}" unless value.match?(/\A[\w\d\-]+\z/) }.compact
    end
  
    def validate_numerical_values(values, key)
      values.map { |value| "Invalid #{key}: #{value}" unless value.to_i.between?(0, 5) }.compact
    end
  
    def validate_ami_os(values, key)
      values.map { |value| "Invalid #{key}: #{value}" unless ['windows', 'linux'].include?(value.downcase) }.compact
    end
end

class EC2Validator < ValidateTemplate
    include EC2ValidatorMethods

    def initialize
        super
    end
end