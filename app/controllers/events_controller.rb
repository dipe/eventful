class EventsController < ApplicationController

  before_filter :provide_account, :except => 'create'
  before_filter :authenticate_account_by_api_token, :only => 'create'
  
  def index
    @query = params[:query] || {}
    @query[:account_id] = @account.id
    @page = params[:page] || 1
    @events = WillPaginate::Collection.create(@page, 200, Event.count(@query)) do |pager|
      events = Event.find(@query, :descending => true, :skip => pager.offset, :limit => pager.per_page).to_a
      pager.replace(events)
    end
  end

  def show
    @event = Event.find(params[:id])
  end
  
  def create
    @event = Event.new(params[:event])
    @event.account = @account
    if @event.save
      render :xml => @event, :status => :created, :location => account_event_path(@account, @event)
    else
      render :xml => @event.errors, :status => :unprocessable_entity
    end
  end

  def hide_additional_data_item
    @event = Event.find(params[:id])
    @key = params[:key]
  end

  def show_additional_data_item
    @event = Event.find(params[:id])
    @key = params[:key]
    @item = @event.additional_data.detect { |item| item['key'] == @key }
  end

  private
  
  def authenticate_account_by_api_token
    @account = Account.find_by_api_token(params.delete(:api_token))
  end
  
  def provide_account
    @account = Account.find(params[:account_id]) if params[:account_id]
  end
end
