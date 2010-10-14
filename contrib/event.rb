class Event < ActiveResource::Base
  self.site = "http://localhost:3112/"

  # self.proxy = "http://user:password@proxy.people.com:8080"

  self.timeout = 3 # seconds

  # Uncomment the following line if you plan to name this class other
  # than Event:
  #
  # self.element_name = "event"

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
  
  def self.put(params)
    event = new
    params.each_pair do |name, value|
      event.send("#{name}=", value)
    end

    begin
      event.save
    rescue Errno::ECONNREFUSED
      -1
    end
  end
end
