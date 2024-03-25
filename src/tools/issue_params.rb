
class IssueParams
  def initialize(body)
    @body = body
  end

  def get_params()
    parsed_input = {}

    lines = @body.split("\n")
    lines.each do |line|
      if line.match(/^:(\w+):\s*(.+)$/)
        key = $1.to_sym
        values = $2.split(",").map(&:strip)
        parsed_input[key] = values
      end
    end
    parsed_input.each do |key, value|
      puts "#{key}: #{value}"
    end
    return parsed_input
  end

end
  