# -*- coding: utf-8 -*-
class Event < CouchModel::Base

  # FIXME: should be moved into environment/….rb
  CouchModel::Configuration.design_directory = File.join(Rails.root, "app", "models", "designs")
  setup_database :url => "http://localhost:5984/eventful-#{Rails.env}",
    :create_if_missing => true,
    :delete_if_exists => false,
    :push_design => true

  before_save :set_default_values

  # Account must be given - but for secutity reasons by explicit
  # assignment only
  include ActiveModel::MassAssignmentSecurity
  attr_protected :account_id
  validates_presence_of :account_id

  belongs_to :account, :class_name => "Account"

  delegate :application, :to => :account
  
  key_accessor :level
  key_accessor :title
  key_accessor :message
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
    res = find_by_view(query, options.merge(:returns => :rows, :group_level => 0))
    return 0 if res.length == 0
    res.first.value
  end

  def self.find_by_view(query, options = {})
    q = query.with_indifferent_access
    columns = columns_from(q)
 
    if columns.empty?
      all(options)
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
    "find_by_" + columns.join('_and_')
  end

  def self.columns_from(query)
    %w(account_id controller action title).select { |c| query.has_key? c }
  end

  def set_default_values
    self.created_at ||= Time.now
  end

  def level_name
    I18n.t("display_values.event.level.#{level}")
  end

  def level
    attributes['level'] || 1
  end

  def find_all_like_this
    find(all_like_this_query)
  end

  def count_all_like_this
    count(all_like_this_query)
  end

  def all_like_this_query
    { :account_id => account_id,
      :controller => controller,
      :action => action,
      :title => title
    }
  end
end
