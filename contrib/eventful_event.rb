module Eventful
  class Event < ActiveResource::Base
    self.site = "http://0.0.0.0:3000"

    # self.proxy = "http://user:password@proxy.people.com:8080"

    self.timeout = 3 # seconds

    # Uncomment the following line if you plan to name this class other
    # than Event:
    #
    # self.element_name = "event"

    def self.put(params = {})
      event = new

      event.application = Rails.application.class.to_s.split("::").first
      event.environment = Rails.env
      event.node = `hostname -s`.chomp
      event.pid = $$

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

    def exception=(exception)
      self.title = exception.class.name
      self.message = exception.message
      self.backtrace = exception.backtrace.join("\n") if exception.backtrace
    end

    def request=(request)
      self.request_data_type = :yaml
      self.request_data = request.to_yaml
      self.request_url = request.url
      self.request_host = (request.env["HTTP_X_FORWARDED_HOST"] || request.env["HTTP_HOST"])
      self.request_ip = request.ip
      
      self.request_params = request.params.to_yaml
      self.controller = request.params[:controller]
      self.action = request.params[:action]
      
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
