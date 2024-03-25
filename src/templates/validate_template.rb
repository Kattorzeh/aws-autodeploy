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
      errors = []
  
      validate_ec2_instances(params[:ec2_instances], errors)
      validate_ec2_name(params[:ec2_name], errors)
      validate_ec2_instance_type(params[:ec2_instance_type], errors)
      validate_ec2_ami_os(params[:ec2_ami_os], errors)
      validate_ec2_ami(params[:ec2_ami], errors)
      validate_ec2_tags(params[:ec2_tags], errors)
  
      errors
    end
  
    private
  
    def validate_ec2_instances(instances, errors)
        return unless instances
      
        errors.concat(EC2Validator.validate_ec2_instances(instances))
    end      
  
    def validate_ec2_name(name, errors)
      return unless name
  
      errors.concat(EC2Validator.validate_ec2_name(name[0]))
    end
  
    def validate_ec2_instance_type(instance_types, errors)
      return unless instance_types
  
      instance_types.each do |instance_type|
        errors.concat(EC2Validator.validate_ec2_instance_type(instance_type, @aws_ec2_client))
      end
    end
  
    def validate_ec2_ami_os(ami_os, errors)
      return unless ami_os
  
      errors.concat(EC2Validator.validate_ec2_ami_os(ami_os[0]))
    end
  
    def validate_ec2_ami(ami_ids, errors)
      return unless ami_ids
  
      ami_ids.each do |ami_id|
        errors.concat(EC2Validator.validate_ec2_ami(ami_id, @aws_ec2_client))
      end
    end
  
    def validate_ec2_tags(tags, errors)
      return unless tags
  
      errors.concat(EC2Validator.validate_ec2_tags(tags))
    end
  end
  
