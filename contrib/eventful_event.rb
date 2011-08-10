# -*- coding: utf-8 -*-
# EventfulEvent

require 'uri'
require 'net/http'
require 'singleton'

module EventfulEvent
  class Base

    include Singleton

    # EventfulEvent.fire is a shortcut method to fire a new exception
    # event. It's accept a hash with the following parameters:
    #
    # * exception - the exeption object to track
    # * request - the rails request object involved
    # * extra - a optional list of additionally data you want to track with
    # * level - a small integer describing the error level
    #
    # Example:
    #
    #   # Setup EventfulEvent with your api_token in the configuration part
    #   # of your code:
    #
    #   EventfulEvent.api_token = 'your api token'
    #   EventfulEvent.endpoint = 'http://your.eventful.srv:1234/'
    #
    #   # later in the work part your code:
    #   
    #   begin
    #     # doing delicate and eventful things…
    #     …
    #   rescue Exception => e
    #     EventfulEvent.fire(
    #       :request => request,
    #       :exception => e,
    #       :extra => {:key => 'SOAP', :value => some_xml_data, :type => :xml}
    #     )
    #  end
    #
    def self.fire(params)
      instance.node = `hostname -s`.chomp
      instance.pid = $$
      instance.additional_data = []
      params.each_pair { |name, value| instance.send("#{name}=", value) }

      instance.fire
    end

    def self.api_token=(api_token)
      instance.api_token = api_token
    end

    def self.endpoint=(endpoint)
      instance.endpoint = URI.parse(endpoint)
    end

    def self.timeout=(timeout)
      instance.timeout = timeout
    end
    
    attr_accessor(:api_token,
                  :endpoint,
                  :timeout,
                  :level,
                  :node,
                  :pid,
                  :title,
                  :message,
                  :request_host,
                  :request_url,
                  :request_ip,
                  :action,
                  :controller,
                  :session_id,
                  :additional_data,
                  :created_at
                  )

    def fire
      begin
        post :header => {"Accept" => "application/json", "Content-Type" => "application/json"},
             :body => as_json
      rescue Exception => e
        Rails.logger.error("Can't send Eventful Event: #{e.inspect} (ignored)")
        false
      else
        analyse_response
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

  private

    def add_additional_data(key, value, type = 'yaml')
      additional_data << {:key => key.to_s, :value => value.to_s, :type => type.to_s}
    end

    def extract_env_from_request(request)
      request.env.slice(*request.env.keys.grep(/[A-Z]/))
    end

    def as_json
      { :event => {
          :api_token => api_token,
          :created_at => created_at,
          :level => level,
          :node => node,
          :pid => pid,
          :title => title,
          :message => message,
          :request_host => request_host,
          :request_url => request_url,
          :request_ip => request_ip,
          :action => action,
          :controller => controller,
          :session_id => session_id,
          :additional_data => additional_data,
        }}.to_json
    end
    
    def header
      @params[:header] || {}
    end

    def body
      @params[:body].to_s
    end
    
    def post(params)
      @params = params
      @response = Net::HTTP.start(endpoint.host, endpoint.port) do |connection|
        connection.read_timeout = timeout || 3
        connection.open_timeout = timeout || 3
        connection.post('/events', body, header)
      end
    end
    
    def analyse_response
      @response.code == 201
    end
  end
end
