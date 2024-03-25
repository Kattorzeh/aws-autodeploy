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
    params.each do |key, values|
      if key.to_s.start_with?('ec2_')
        validation_method = "validate_#{key}".to_sym
        if respond_to?(validation_method, true)
          errors.concat(send(validation_method, values, @aws_ec2_client))
        else
          puts "No validation method found for key: #{key}"
        end
      end
    end
    errors
  end
end
  
