class EventsController < ApplicationController

  respond_to :js, :html
  
  def index
    @events = Event.all.sort_by { |e| e.created_at.to_s }.reverse
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
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def hide_request_data
  end

  def show_request_data
    @event = Event.find(params[:id])
    respond_with @events
  end
end
