require 'actions/action'

class ValidateAction < Action
    attr_reader :success

    def execute(issue,issue_params)
        Log.info(LOG_COMP, "Validating template")
        Log.info(LOG_COMP, "Issue Params: #{issue_params}")

        '''
        issue_number = issue['number']
        issue_title = issue['title']
        issue_body = issue['body']

        comments = issue['comments']
        labels = issue['labels']
        state = issue['state']
        created_at = issue['created_at']
        updated_at = issue['updated_at']
    
        Log.info(LOG_COMP, "issue Num: #{issue_number}")
        Log.info(LOG_COMP, "Issue Title: #{issue_title}")
        Log.info(LOG_COMP, "Issue Body: #{issue_body}")

        Log.info(LOG_COMP, "Comments: #{comments}")
        Log.info(LOG_COMP, "Labels: #{labels}")
        Log.info(LOG_COMP, "State: #{state}")
        Log.info(LOG_COMP, "Creation Date: #{created_at}")
        Log.info(LOG_COMP, "Last Updated Date: #{updated_at}")
        '''
    end

    def report()
        Log.info(LOG_COMP, "Reporting Validation")
    end
end