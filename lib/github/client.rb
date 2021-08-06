module Github
  class Client
    def initialize(handle)
      @handle = handle
    end

    def get_events
      begin
        response_body = JSON.parse(get_user_events.body)
      
        return response_body if response_body.is_a? Array
        
        raise Exception.new(response_body.key?("message") ? response_body["message"] : "Unknown error") 
    
      rescue Exception => e
        print "Request failed with #{e.message}"
        []
      end
    end

    private

    def get_user_events
      Net::HTTP.get_response(URI.parse("https://api.github.com/users/#{@handle}/events/public"))
    end
  end
end
