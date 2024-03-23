require 'json-schema'

class ValidateTemplate
    LOG_COMP = 'VAL_TEMP'

    # Default Values
    DEFAULT_PROVIDER    = 'aws'
    AWS_REGION          = 'eu-central-1'
    AWS_SIZE            = 't2.micro'

    # EC2 Configuration Schema
    EC2_SCHEMA = {
        :type => :object,
        :properties => {
            'ec2_name' => {
                :type => :string,
                :required => true
            },
            'mail' => {
                :type => :string,
                :format => :email,
                :required => false
            },
            'instances' => {
                :type => :integer,
                :required => false,
                :minimum => 1,
                :maximum => 5,
            },
            'aws_region' => {
                :type => :string,
                :required => false,
                :default => AWS_REGION,
                :enum => %w[
                    eu-central-1
                ]
            },
            'instance_type' => {
                :type => :string,
                :required => false,
                :default => AWS_SIZE,
                :enum => %w[
                    t2.micro
                    t2.medium
                ]
            }
        }
    }

end
