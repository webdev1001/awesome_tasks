class TimelogsController < ApplicationController
  before_filter :set_timelog
  
  def index
  end
  
  def new
    @timelog = Timelog.new(
      :date => Time.zone.today.to_date,
      :time => "00:00:00",
      :time_transport => "00:00:00"
    )
    @timelog.assign_attributes(timelog_params) if params[:timelog]
    
    render :new, :layout => false
  end
  
  def create
    @timelog = Timelog.new(timelog_params)
    
    if @timelog.save
      render :nothing => true
    else
      render :text => _("Could not save: %{errors}", :errors => @timelog.errors.full_messages.join(". "))
    end
  end
  
  def edit
    render :edit, :layout => false
  end
  
  def update
    if @timelog.update_attributes(timelog_params)
      render :nothing => true
    else
      render :text => _("Could not save: %{errors}", :errors => @timelog.errors.full_messages.join(". "))
    end
  end
  
private
  
  def set_timelog
    @timelog = Timelog.find(params[:id]) if params[:id]
  end
  
  def timelog_params
    params.require(:timelog).permit(:task_id, :time, :time_transport, :transport_length,
      :date, :invoiced, :comment)
  end
end
