class Event < CouchModel::Base

  before_save :set_default_values
  
  setup_database :url => "http://localhost:5984/eventful-#{Rails.env}",
    :create_if_missing => true,
    :delete_if_exists => false,
    :push_design => true

  key_accessor :level
  key_accessor :title
  key_accessor :message
  key_accessor :application
  key_accessor :environment
  key_accessor :version
  key_accessor :controller
  key_accessor :action
  key_accessor :request_url
  key_accessor :request_params
  key_accessor :request_data_type
  key_accessor :request_data
  key_accessor :session_id
  key_accessor :session_data_type
  key_accessor :session_data
  key_accessor :additional_data_type
  key_accessor :additional_data
  key_accessor :backtrace
  key_accessor :node
  key_accessor :pid
  key_accessor :created_at, :type => :time

  def set_default_values
    self.created_at ||= Time.now
  end

  def level_name
    I18n.t("display_values.event.level.#{level || 0}")
  end
  
  def to_s
    "#{created_at}: #{level_name} #{application}-#{environment}@#{node} (#{controller}##{action}) #{title} [#{message}]"
  end
end
