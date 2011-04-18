# -*- coding: utf-8 -*-

# TODO:
# - Port auf Net::Http
# - Modularisieren: Base und Rails
# - Protokoll: xml oder json? (was ist mit Binärdaten)
#
module Eventful
  class Event < ActiveResource::Base

    # self.proxy = "http://user:password@proxy.people.com:8080"
    self.site = "http://0.0.0.0:3000"

    # Timemout
    self.timeout = 3 # seconds

    # Eventful::Event.fire is a shortcut method to fire a new exception
    # event. It's accept a hash with the following parameters:
    #
    # * api_token - the api access token for your application account
    # * exception - the exeption object to track
    # * request - the rails request object involved
    # * extra - a optional list of additionally data you want to track with
    #
    # Example:
    #   # Setup Eventful with your api_token in the initalization
    #   # part of your code:
    #   Eventful::Event.api_token = your_api_token
    #
    #   # later in the work part your code:
    #   
    #   begin
    #     # doing delicate and eventful things…
    #     …
    #   rescue Exception => e
    #     Eventful::Event.fire(
    #       :request => request,
    #       :exception => e,
    #       :extra => {:key => 'SOAP', :value => some_xml_data, :type => :xml}
    #     )
    #  end
    #
    def self.fire(params)
      begin
        event = new
        event.node = `hostname -s`.chomp
        event.pid = $$
        event.additional_data = []

        params.each_pair do |name, value|
          event.send("#{name}=", value)
        end
      
        event.save
      rescue ActiveResource::TimeoutError
        Rails.logger.error('Eventful::Event: Timeout Error ignored')
        -1
      rescue Errno::ECONNREFUSED
        Rails.logger.error('Eventful::Event: Connection Error ignored')
        -1
      rescue Exception => e
        Rails.logger.error("Eventful::Event: #{e.inspect} ignored.\n#{e.backtrace.join("\n")}")
      else
        unless event.valid?
          Rails.logger("Eventful::Event: Error: #{event.errors.full_messages.join(' - ')}")
        end
      end
    end

    def exception=(exception)
      self.title = exception.class.name
      self.message = exception.message
      add_additional_data(:backtrace, exception.backtrace.join("\n")) if exception.backtrace
    end

    def request=(request)
      self.request_url = request.url
      self.request_host = (request.env["HTTP_X_FORWARDED_HOST"] || request.env["HTTP_HOST"])
      self.request_ip = request.ip
      self.controller = request.params[:controller]
      self.action = request.params[:action]
      self.session_id = request.session_options[:id]
      
      add_additional_data(:request_params, request.params.to_yaml)
      add_additional_data(:request_env, extract_env_from_request(request).to_yaml)
      add_additional_data(:session, request.session.to_yaml)
    end

    def extra=(extra_data)
      return unless extra_data.is_a? Hash
      add_additional_data(extra_data[:key], extra_data[:value], extra_data[:type])
    end

    def add_additional_data(key, value, type = 'yaml')
      additional_data << {:key => key.to_s, :value => value.to_s, :type => type.to_s}
    end

    def extract_env_from_request(request)
      request.env.slice(*request.env.keys.grep(/[A-Z]/))
    end
  end
end
