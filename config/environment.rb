# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Eventful::Application.initialize!

# Where are the sources for the design docucuments (couchdb views)?
CouchModel::Configuration.design_directory = File.join(Rails.root, "app", "models", "designs")
