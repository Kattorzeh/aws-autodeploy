#!/usr/bin/env ruby

require 'uri'
require 'json'
require 'net/http'
require 'tools/log'

class Github_client

    LOG_COMP = 'GH'

    GH_URL_BASE = 'https://api.github.com/repos/'
    repo_name = ENV['GITHUB_REPOSITORY']
    GH_URL = "#{GH_URL_BASE}#{repo_name}"

    # Obtain Issue details
    def self.get_issue(issue_number)
        Log.info(LOG_COMP, 'Configuring github client')
        
        uri = URI("#{GH_URL}/issues/#{issue_number}")
        req = Net::HTTP::Get.new(uri)
        req['Accept'] = 'application/vnd.github.v3+json'
        req['Authorization'] = "token #{ENV['GH_TOKEN']}"
        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
            http.request(req)
        end

        unless res.is_a?(Net::HTTPSuccess)
            Log.error(LOG_COMP, "Error fetching the issue from github: #{res}")
            raise "Error fetching issue details: #{res.message}"
        end

        JSON.parse(res.body)
    end

end
