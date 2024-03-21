require 'actions/action'

class ValidateAction < Action
    attr_reader :success

    def execute()
        Log.info(LOG_COMP, "Validating template")
    end
end