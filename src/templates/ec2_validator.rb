require 'aws-sdk-ec2'

class EC2Validator

    # Default Values
    AWS_EC2_TYPE        = 't2.micro'
    AWS_EC2_INSTANCES   = 0


    def self.validate_ec2_instances(instances)
        errors = []
        if instances.nil? || instances.length != 1 || !instances[0].match?(/\A[0-5]\z/)
            errors << "EC2 instances should be an array containing a single digit between 0 and 5."
        end
        errors
    end

    def self.validate_ec2_name(name)
        errors = []
        unless name.nil? || name.match?(/\A[\w\-]+\z/)
            errors << "EC2 name should only contain letters, numbers, hyphens, and underscores."
        end
        errors
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

    def self.validate_ec2_ami_os(ami_os)
        errors = []
        unless ami_os.nil? || %w[windows linux].include?(ami_os)
            errors << "EC2 AMI OS should be either 'windows' or 'linux'."
        end
        errors
    end
    
    def self.validate_ec2_ami(ami_ids, aws_ec2_client)
        errors = []
        if ami_ids.nil?
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
    
    def self.validate_ec2_tags(tags)
        errors = []
        unless tags.nil? || tags.all? { |tag| tag.match?(/\A[\w\-]+\z/) }
            errors << "EC2 tags should only contain letters, numbers, hyphens, and underscores."
        end
        errors
    end
end