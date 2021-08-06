require 'github/client'
require 'net/http'
require 'uri'
require 'json'

module Github
  class Score
    SCORING_PARAMS = {
      "IssuesEvent" => 1,
      "IssueCommentEvent" => 2,
      "PushEvent" => 3,
      "PullRequestReviewCommentEvent" => 4,
      "WatchEvent" => 5,
      "CreateEvent" => 6
    }.freeze

    def initialize(handle)
      @handle = handle
    end

    def score
      get_score(Github::Client.new(handle).get_events)
    end
  
    private

    attr_accessor :handle

    def get_score(events)
      events.sum{ |event| SCORING_PARAMS[event['type']] || 1 }
    end
  end
end

