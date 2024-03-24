require 'json'
require 'aws-sdk-ec2'

class ValidateTemplate
    LOG_COMP = 'VAL_TEMP'

    
    def initialize
        # AWS Clients
        Aws.config.update({
            credentials: Aws::Credentials.new(ENV['ACCESS_KEY_ID'], ENV['SECRET_ACCESS_KEY']),
            region: ENV['REGION']
        })
        aws_ec2_client = Aws::EC2::Client.new

        # AWS-EC2-TYPE
        response_type = aws_ec2_client.describe_instance_type_offerings(
            filters: [{ name: 'instance-type', values: ['m1.nano'] }]
        )
        puts response_type
        if response_type.instance_type_offerings.any?
            puts "'m1.nano' IS present."
        else
            puts "'m1.nano' IS NOT present."
        end

        response_bad_type = aws_ec2_client.describe_instance_type_offerings(
            filters: [{ name: 'instance-type', values: ['mario'] }]
        )
        puts response_bad_type

        # AWS-EC2-AMI
        response_ami = aws_ec2_client.describe_images(image_ids: ['ami-0183b16fc359a89dd'])
        ami = response_ami.images[0]
        puts "AMI ID: #{ami.image_id}"
        puts "AMI Name: #{ami.name}"
        puts "AMI Desc: #{ami.description}"

        begin
            response_bad_ami = aws_ec2_client.describe_images(image_ids: ['ami-0'])
            puts response_bad_ami
        rescue Aws::EC2::Errors::InvalidAMIIDNotFound => e
            puts "Error: #{e.message}"
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
                #:enum => aws_ec2_types
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
