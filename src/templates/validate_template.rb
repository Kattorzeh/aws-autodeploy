require 'aws-sdk-ec2'

class ValidateTemplate
  LOG_COMP = 'VAL_TEMP'

  def initialize
    Aws.config.update({
      credentials: Aws::Credentials.new(ENV['ACCESS_KEY_ID'], ENV['SECRET_ACCESS_KEY']),
      region: ENV['REGION']
    })
    @aws_ec2_client = Aws::EC2::Client.new
  end

  def validate(params)
    ec2_validations = {
      ec2_instances: { regex: /\A[0-5]\z/, message: "be a number between 0 and 5" },
      ec2_name: { regex: /\A[a-zA-Z0-9\-_]+\z/, message: "contain only characters, numbers, - or _" },
      ec2_ami_os: { options: ["windows", "linux"], message: "be 'windows' o 'linux'" },
      ec2_tags: { regex: /\A[a-zA-Z0-9\-_]+\z/, message: "contain only characters, numbers, - or _" }
    }

    params.each do |key, values|
      next unless ec2_validations[key]
  
      values.each do |value|
        if value.empty? 
          default_value = default_value_for_key(key)
          puts "Warning: No value provided for '#{key}'. Default value '#{default_value}' will be applied."
          value = default_value
        end
  
        if ec2_validations[key][:regex]
          unless value.match?(ec2_validations[key][:regex])
            puts "Error: value '#{value}' for '#{key}' not validated. It should #{ec2_validations[key][:message]}"
          end
        elsif ec2_validations[key][:options]
          unless ec2_validations[key][:options].include?(value)
            puts "Error: value '#{value}' for '#{key}' not validated. It should #{ec2_validations[key][:message]}"
          end
        end
      end
    end

    # ec2_instance_type & ec2_ami specific valdiation (API AWS)
    validate_ec2_instance_type(params[:ec2_instance_type]) if params.key?(:ec2_instance_type)
    validate_ec2_ami(params[:ec2_ami]) unless params[:ec2_ami].nil? || params[:ec2_ami].empty?
  end


  def default_value_for_key(key)
    case key
    when :ec2_instances
      "0"
    when :ec2_name
      "aws-autodeploy" 
    when :ec2_ami_os
      "linux"
    when :ec2_tags
      "github" 
    end
  end

  def validate_ec2_instance_type(instance_types)
    errors = []
    instance_types.each do |instance_type|
      if instance_type.nil?
        errors << "EC2 instance type is not specified."
      else
        response_type = @aws_ec2_client.describe_instance_type_offerings(
          filters: [{ name: 'instance-type', values: [instance_type] }]
        )
        if response_type.instance_type_offerings.empty?
          errors << "The instance type '#{instance_type}' is not valid."
        end
      end
    end
    errors.each { |error| puts error }
  end
  
  def validate_ec2_ami(ami_ids)
    errors = []
    ami_ids.each do |ami_id|
      if ami_id.nil?
        errors << "EC2 AMI is not specified."
      else
        begin
          response_bad_ami = @aws_ec2_client.describe_images(image_ids: [ami_id])
        rescue Aws::EC2::Errors::InvalidAMIIDMalformed => e
          errors << "AMI ID '#{ami_id}' is malformed."
        rescue Aws::EC2::Errors::InvalidAMIIDNotFound => e
          errors << "AMI '#{ami_id}' not found."
        end
      end
    end
    errors.each { |error| puts error }
  end
  
end

  
