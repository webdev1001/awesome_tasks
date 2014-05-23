class TimelogsController < ApplicationController
  before_filter :set_timelog
  
  def index
    @ransack_params = params[:q] || {}
    
    if params["choice"] == "dosearch"
      begin
        @date_from = Datet.in(params["texdatefrom"])
      rescue
        flash[:warning] = (_("Invalid date-from."))
        redirect_to :back
      end
      
      begin
        @date_to = Datet.in(params["texdateto"])
      rescue
        flash[:warning] = (_("Invalid date-to."))
        redirect_to :back
      end
    else
      @date_from = Datet.new
      @date_from.day = 1
      
      @date_to = Datet.new
      @date_to.day = @date_to.days_in_month
    end
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
  
  def destroy
    @timelog.destroy
    render :nothing => true
  end
  
  def mark_invoiced
    params["tlog_ids"].to_s.split(";").each do |timelog_id|
      next unless timelog_id.to_i > 0
      timelog = Timelog.find(timelog_id)
      timelog.invoiced = true
      timelog.save!
    end
    
    render :nothing => true
  end
  
private
  
  def set_timelog
    if params[:id]
      @timelog = Timelog.find(params[:id])
      authorize! action_name.to_sym, @timelog
    else
      authorize! action_name.to_sym, Timelog
    end
  end
  
  def timelog_params
    params.require(:timelog).permit(:task_id, :time, :time_transport, :transport_length,
      :date, :invoiced, :comment)
  end
  
  helper_method :timelogs_from_params
  def timelogs_from_params
    args = {}
    tlogs = Timelog.ransack(@ransack_params).result.order(:date)
    
    if params["texdatefrom"].to_s.length > 0
      tlogs = tlogs.where("timelogs.date >= ?", @date_from.to_time)
    end
    
    if params["texdateto"].to_s.length > 0
      tlogs = tlogs.where("timelogs.date <= ?", @date_to.to_time)
    end
    
    if params["users"].to_s.length > 0
      tlogs = tlogs.where("timelogs.user_id IN (?)", params["users"].to_s.split(";"))
    end
    
    if params["projects"].to_s.length > 0
      tlogs = tlogs.joins(:task).where("tasks.project_id IN (?)", params["projects"].to_s.split(";"))
    end
    
    if params["selinvoiced"].to_s == "1"
      tlogs = tlogs.where("timelogs.invoiced = '1'")
    elsif params["selinvoiced"].to_s == "0"
      tlogs = tlogs.where("timelogs.invoiced != '1'")
    end
    
    return tlogs
  end
end
