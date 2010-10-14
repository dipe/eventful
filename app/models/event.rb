class Event < CouchRest::Model::Base

  couch = CouchRest.new
  couch.default_database = "eventful-#{Rails.env}"
  use_database couch.default_database

  property :title, String
  property :message, String
  property :created_at, Time
  property :application, String
  property :environment, String
  property :version, String
  property :controller, String
  property :action, String
  property :request_url, String
  property :request_params, String
  property :request_data_type, String
  property :request_data, String
  property :session_id, String
  property :session_data_type, String
  property :session_data, String
  property :additional_data_type, String
  property :additional_data, String
  property :backtrace, String
  property :node, String
  property :pid, String
end
