require 'json-schema'
require 'aws-sdk-ec2'

class EC2Validator

    # Default Values
    AWS_EC2_TYPE        = 't2.micro'
    AWS_EC2_INSTANCES   = 0
    
    # EC2 Configuration Schema
    EC2_SCHEMA = {
        type: :object,
        properties: {
            'ec2_name' => {
            type: :string,
            pattern: '^[a-zA-Z0-9_-]+$',
            required: false
            },
            'ec2_instances' => {
            type: :integer,
            required: false,
            pattern: '^[1-5]$',
            default: AWS_EC2_INSTANCES,
            minimum: 1,
            maximum: 5,
            },
            'ec2_instance_type' => {
            type: :string,
            required: false,
            default: AWS_EC2_TYPE,
            },
            'ec2_ami_os' => {
            type: :string,
            required: false,
            enum: %w[linux windows]
            },
            'ec2_ami' => {
            type: :string,
            required: false,
            },
            'ec2_tags' => {
            type: :string,
            pattern: '^[a-zA-Z0-9_-]+$',
            required: false
            }
        },
        additionalProperties: false # No extra properties accepted
    }

     # Function to validate the EC2 instance type
    def self.validate_ec2_instance_type(instance_type,aws_ec2_client)
        errors = []

        unless instance_types.nil? || instance_types.empty?
            instance_types.each do |instance_type|
            if instance_type.nil? || instance_type.empty?
                errors << "EC2 instance type is empty."
            else
                response_type = aws_ec2_client.describe_instance_type_offerings(
                filters: [{ name: 'instance-type', values: [instance_type] }]
                )
                if response_type.instance_type_offerings.empty?
                errors << "The instance type '#{instance_type}' is not valid."
                end
            end
            end
        end
        
        errors
    end

    # Function to validate the EC2 AMI
    def self.validate_ec2_ami(ami_id,aws_ec2_client)
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