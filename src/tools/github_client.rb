#!/usr/bin/env ruby

require 'uri'
require 'json'
require 'net/http'
require 'tools/log'

class Github

    LOG_COMP = 'GH'

    GH_URL = 'https://api.github.com/repos/Kattorzeh/aws-autodeploy/'

    # Obtain Issue details
    def get_issue(issue_number)
        Log.info(LOG_COMP, 'Configuring github client')
        uri = URI("#{GH_URL}/issues/#{issue_number}")
        req = Net::HTTP::Get.new(uri)
        req['Accept'] = 'application/vnd.github.v3+json'
        req['Authorization'] = "token #{ENV['GH_TOKEN']}"


        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
            http.request(req)
        end

        unless res.is_a?(Net::HTTPSuccess)
            Log.error(LOG_COMP, "Error fetching the issue from github: #{res.message}")
            raise "Error fetching issue details: #{res.message}"
        end

        JSON.parse(res.body)
    end

end
