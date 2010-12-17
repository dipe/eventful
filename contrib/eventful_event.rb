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
      event.additional_data = []

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
      add_extra_data(:backtrace, exception.backtrace.join("\n")) if exception.backtrace
    end

    def request=(request)
      self.request_url = request.url
      self.request_host = (request.env["HTTP_X_FORWARDED_HOST"] || request.env["HTTP_HOST"])
      self.request_ip = request.ip
      self.controller = request.params[:controller]
      self.action = request.params[:action]
      self.session_id = request.session_options[:id]
      
      add_extra_data(:request_params, request.params.to_yaml)
      add_extra_data(:request, request.to_yaml)
      add_extra_data(:session, request.session.to_yaml)
    end

    def extra=(hash)
      add_extra_data(hash[:key], hash[:value], hash[:type])
    end

    def add_extra_data(key, value, type = 'yaml')
      additional_data << {:key => key.to_s, :value => value.to_s, :type => type.to_s}
    end
  end
end
