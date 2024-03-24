require 'json'
require 'aws-sdk-ec2'

class ValidateTemplate
    LOG_COMP = 'VAL_TEMP'

    # AWS Clients
    Aws.config.update({
        credentials: Aws::Credentials.new(ENV['ACCESS_KEY_ID'], ENV['SECRET_ACCESS_KEY']),
        region: ENV['REGION']
    })
    aws_ec2_client = Aws::EC2::Client.new

    # AWS Data
    response = aws_ec2_client.describe_instance_types
    aws_ec2_types = response.instance_types.map(&:instance_type)
    
    def initialize
        aws_ec2_types.each do |instance_type|
          puts instance_type
        end
    end
    # Default Values
    DEFAULT_PROVIDER    = 'aws'
    AWS_REGION          = 'eu-central-1'
    AWS_EC2_TYPE        = 't2.micro'
    
    # EC2 Configuration Schema
    EC2_SCHEMA = {
        :type => :object,
        :properties => {
            'ec2_name' => {
                :type => :string,
                :required => false
            },
            'ec2_instances' => {
                :type => :integer,
                :required => false,
                :minimum => 1,
                :maximum => 5,
            },
            'instance_type' => {
                :type => :string,
                :required => false,
                :default => AWS_EC2_TYPE,
                :enum => aws_ec2_types
            },
            'ec2_ami_os' => {
                type: :string,
                required: false,
                enum: %w[linux windows]
            },
            'ec2_ami' => {
                type: :string,
                required: false,
                pattern: '^ami-[a-f0-9]+$'
            },
            'ec2_tags' => {
                type: :string,
                required: false
            }
        },
        additionalProperties: false # No extra properties accepted
    }

end
