require 'aws-sdk-ec2'
require_relative 'ec2_validator'

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
    validations = {
      ec2_instances: { regex: /\A[0-5]\z/, message: "debe ser un número entre 0 y 5" },
      ec2_name: { regex: /\A[a-zA-Z0-9\-_]+\z/, message: "debe contener solo letras, números, guiones y guiones bajos" },
      ec2_ami_os: { options: ["windows", "linux"], message: "debe ser 'windows' o 'linux'" },
      ec2_tags: { regex: /\A[a-zA-Z0-9\-_]+\z/, message: "debe contener solo letras, números, guiones y guiones bajos" }
    }

    params.each do |key, values|
      next unless validations[key]

      values.each do |value|
        if validations[key][:regex]
          unless value.match?(validations[key][:regex])
            puts "Error: value '#{value}' for '#{key}' no validated. It should be #{validations[key][:message]}"
          end
        elsif validations[key][:options]
          unless validations[key][:options].include?(value)
            puts "Error: value '#{value}' for '#{key}' no validated. It should be #{validations[key][:message]}"
          end
        end
      end
    end
  end

end

  
