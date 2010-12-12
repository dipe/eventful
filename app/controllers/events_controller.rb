class EventsController < ApplicationController

  respond_to :js, :html
  
  def index
    @events = Event.all.to_a.sort_by { |e| e.created_at }.reverse
    respond_with @events
  end

  def show
    @event = Event.find(params[:id])
    respond_with @events
  end

  def create
    @event = Event.new(params[:event])
    
    respond_to do |format|
      if @event.save
        format.html { redirect_to(@event, :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        render :xml => @event.errors, :status => :unprocessable_entity
      end
    end
  end

  def hide_additional_data_item
    @event = Event.find(params[:id])
    @key = params[:key]
    respond_with @events
  end

  def show_additional_data_item
    @event = Event.find(params[:id])
    @key = params[:key]
    @item = @event.additional_data.detect { |item| item['key'] == @key }
    respond_with @events
  end
end
