class EventsController < ApplicationController

  def index
    @events = Event.recend(:descending => true).to_a
  end

  def search
    if params[:search][:contoller] && params[:search][:action]
      startkey = params[:search].values_at(:environment, :application, :contoller, :action, :title)
      events = Event.by_environment_and_application_and_controller_and_action_and_title(:startkey => startkey)
    elseif params[:search][:node]
      startkey = params[:search].values_at(:environment, :application, :node)
      events = Event.by_environment_and_application_and_node(:startkey => startkey)
    else
      startkey = params[:search].values_at(:environment, :application, :title)
      events = Event.by_environment_and_application_and_title(:startkey => startkey)
    end

    @events = events.to_a.sort_by(&:created_at).reverse
    render :action => 'index'
  end
  
  def show
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(params[:event])
    if @event.save
      render :xml => @event, :status => :created, :location => @event
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
end
