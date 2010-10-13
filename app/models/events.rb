class Events < CouchRest::Model::Base
  property :title, String
  property :message, String
  property :created_at, Datetime
  property :application, String
  property :environment, String
  property :controller, String
  property :action, String
  property :request_url, Text
  property :request_params, Text
  property :request_data_type, String
  property :request_data, Text
  property :session_id, String
  property :session_data_type, String
  property :session_data, Text
  property :additional_data_type, String
  property :additional_data, Text
  property :backtrace, Text
  property :node, String
  property :pid, String
end
