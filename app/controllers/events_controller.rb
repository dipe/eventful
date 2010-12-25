class EventsController < ApplicationController

  def index
    @events = Event.all(:descending => true, :limit => 200).to_a
  end

  def search
    @events = Event.search(params[:search], :descending => true, :limit => 200).to_a
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
