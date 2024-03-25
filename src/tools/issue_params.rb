
class IssueParams
    def initialize(body)
      @body = body
    end
  
    def get_params()
      params = {}

      matches = @body.scan(/:(\w+):\s*["']?(.*?)["']?(?:,|$)/)
      matches.each do |match|
        param = match[0]
        value = match[1].split(',')
        
        # Quit \r 
        value.map!(&:chomp)

        if params.key?(param.to_sym)
          if params[param.to_sym].is_a?(Array)
            params[param.to_sym] += value
          else
            params[param.to_sym] = [params[param.to_sym]] + value
          end
        else
          params[param.to_sym] = value
        end
      end
      puts params
      return params
    end
    
  end
  