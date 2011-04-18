# -*- coding: utf-8 -*-
class Account < CouchModel::Base

  # FIXME: should be moved into environment/….rb
  CouchModel::Configuration.design_directory = File.join(Rails.root, "app", "models", "designs")
  setup_database :url => "http://localhost:5984/eventful-#{Rails.env}",
    :create_if_missing => true,
    :delete_if_exists => false,
    :push_design => true

  validates_presence_of :application

  key_accessor :application

  def api_key
    id
  end
  
  # Actually we (miss-) use the object-id as api-token. Shure we would
  # change this later because of security reasons.
  def self.find_by_api_token(token)
    find(token)
  end
end
