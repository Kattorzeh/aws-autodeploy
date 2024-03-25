
class IssueParams
    def initialize(body)
      @body = body
    end
  
    def get_params()
      params = {}
    
      matches = @body.scan(/:(\w+):\s*["']?(.*?)["']?(?:,|$)/)
      matches.each do |match|
        param = match[0]
        value = match[1].strip.split(',')  #

        # Quit ":"
        param = param.to_sym
    
        # Quit \r 
        value.map!(&:chomp)
    
        # Only 1 value
        if value.length == 1
          value = value.first
        end
    
        # +1 value x key -> converts it into an array (if it sin't it)
        if params.key?(param)
          if params[param].is_a?(Array)
            params[param] << value
          else
            params[param] = [params[param], value]
          end
        else
          params[param] = value
        end
      end
      puts params
      return params
    end
    
  end
  