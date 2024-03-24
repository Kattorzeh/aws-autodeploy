
class IssueParams
    def initialize(body)
      @body = body
    end
  
    def get_params()
      params = {}
  
      matches = @body.scan(/:(\w+):\s*["']?(.*?)["']?\s*(?:\n|\z)/)
      matches.each do |match|
        param = match[0]
        value = match[1].strip.empty? ? nil : match[1].strip
        params[param.to_sym] = value
      end
  
      return params
    end
  end
  