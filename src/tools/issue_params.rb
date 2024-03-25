
class IssueParams
    def initialize(body)
      @body = body
    end
  
    def get_params()
      params = {}

      
      matches = @body.scan(/:(\w+):\s*["']?(.*?)["']?\s*(?:\n|\z)/)
      matches.each do |match|
        param = match[0]
        value = match[1].strip

        # If there is already a value stored for this key, convert the value to an array if it's not already
        if params.key?(param.to_sym)
          if params[param.to_sym].is_a?(Array)
            params[param.to_sym] << value
          else
            params[param.to_sym] = [params[param.to_sym], value]
          end
        else
          params[param.to_sym] = value
        end
      end
      puts params
      return params
    end
  end
  