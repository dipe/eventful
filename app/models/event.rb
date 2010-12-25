class Event < CouchModel::Base

  before_save :set_default_values
  
  CouchModel::Configuration.design_directory = File.join(Rails.root, "app", "models", "designs")  
  setup_database :url => "http://localhost:5984/eventful-#{Rails.env}",
    :create_if_missing => true,
    :delete_if_exists => false,
    :push_design => true

  def self.search(query, options = {})
    if query[:controller] && query[:action] && query[:titel]
      endkey = query.values_at(:environment, :application, :controller, :action, :title)
      startkey = endkey + [{}]
      Event.by_environment_and_application_and_controller_and_action_and_title(options.merge(:endkey => endkey, :startkey => startkey))
    elsif query[:controller] && query[:action]
      endkey = query.values_at(:environment, :application, :controller, :action)
      startkey = endkey + [{}]
      Event.by_environment_and_application_and_controller_and_action(options.merge(:endkey => endkey, :startkey => startkey))
    elsif query[:controller]
      endkey = query.values_at(:environment, :application, :controller)
      startkey = endkey + [{}]
      Event.by_environment_and_application_and_controller(options.merge(:endkey => endkey, :startkey => startkey))
    elsif query[:node]
      endkey = query.values_at(:environment, :application, :node)
      startkey = endkey + [{}]
      Event.by_environment_and_application_and_node(options.merge(:endkey => endkey, :startkey => startkey))
    elsif query[:title]
      endkey = query.values_at(:environment, :application, :title)
      startkey = endkey + [{}]
      Event.by_environment_and_application_and_title(options.merge(:endkey => endkey, :startkey => startkey))
    else
      endkey = query.values_at(:environment, :application)
      startkey = endkey + [{}]
      Event.by_environment_and_application(options.merge(:endkey => endkey, :startkey => startkey))
    end
  end
 
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
    I18n.t("display_values.event.level.#{level}")
  end

  def level
    attributes['level'] || 1
  end
end
