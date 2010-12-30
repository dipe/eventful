# -*- coding: utf-8 -*-
class Event < CouchModel::Base

  before_save :set_default_values
  
  # FIXME: should be moved into environment/….rb
  CouchModel::Configuration.design_directory = File.join(Rails.root, "app", "models", "designs")
  setup_database :url => "http://localhost:5984/eventful-#{Rails.env}",
    :create_if_missing => true,
    :delete_if_exists => false,
    :push_design => true

  def self.find(*args)
    case args.first
    when String
      # find by Id
      super
    when Hash
      # find by query
      query = args.first
      options = args.extract_options!
      find_by_view(query, options.merge(:reduce => false))
    else
      raise ArgumentError
    end
  end

  def self.count(query, options = {})
    find_by_view(query, options.merge(:returns => :rows, :group_level => 0)).first.value
  end

  def self.find_by_view(query, options = {})
    q = query.with_indifferent_access
    columns = columns_from(q)
      
    if columns.empty?
      Event.all(options)
    else
      method = view_method_from(columns)
      startkey = q.values_at(*columns)
      endkey = startkey + [{}]
      
      if options[:descending]
        e = endkey
        endkey = startkey
        startkey = e
      end
      
      Event.send(method, options.merge(:startkey => startkey, :endkey => endkey))
    end    
  end
  
  def self.view_method_from(columns)
    "by_" + columns.join('_and_')
  end

  def self.columns_from(query)
    %w(environment application controller action title node).select { |c| query.has_key? c }
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
