# -*- coding: utf-8 -*-
class Account < CouchModel::Base

  # FIXME: should be moved into environment/….rb
  CouchModel::Configuration.design_directory = File.join(Rails.root, "app", "models", "designs")
  setup_database :url => "http://localhost:5984/eventful-#{Rails.env}",
    :create_if_missing => true,
    :delete_if_exists => false,
    :push_design => true

  validates_presence_of :application

  #has_many :events

  key_accessor :application
end
