module Eventful
  class Event < ActiveResource::Base
    self.site = "http://0.0.0.0:8080"

    # self.proxy = "http://user:password@proxy.people.com:8080"

    self.timeout = 3 # seconds

    # Uncomment the following line if you plan to name this class other
    # than Event:
    #
    # self.element_name = "event"

    def self.put(params = {})
      event = new
      params.each_pair do |name, value|
        event.send("#{name}=", value)
      end

      begin
        event.save
      rescue ActiveResource::TimeoutError
        Rails.logger.error('Eventful::Event: Timeout Error ignored')
        -1
      rescue Errno::ECONNREFUSED
        Rails.logger.error('Eventful::Event: Connection Error ignored')
        -1
      end
    end

    def request=(request)
      self.request_data_type = :yaml
      self.request_data = request.to_yaml
      self.request_url = request.url
      self.request_params = request.params.to_yaml

      self.session_data_type = :yaml
      self.session_data = request.session.to_yaml
      self.session_id = request.session_options[:id]
    end

    def additional=(data)
      self.additional_data_type = :yaml
      self.additional_data = data.to_yaml
    end

  end
end
