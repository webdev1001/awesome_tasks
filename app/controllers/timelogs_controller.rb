class TimelogsController < ApplicationController
  before_filter :set_timelog
  
  def index
    @ransack_params = params[:q] || {}
    @ransack = Timelog.ransack(@ransack_params)
    
    @invoiced_collection = {
      _("All") => "",
      _("Only invoiced") => "only_invoiced",
      _("Only un-invoiced") => "only_not_invoiced"
    }
    
    set_dates
    set_timelogs
  end
  
  def new
    @timelog = Timelog.new(
      :date => Time.zone.today.to_date,
      :time => "00:00:00",
      :time_transport => "00:00:00"
    )
    @timelog.user = current_user
    @timelog.assign_attributes(timelog_params) if params[:timelog]
    
    render :new, :layout => false
  end
  
  def create
    @timelog = Timelog.new(timelog_params)
    @timelog.user = current_user
    
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
  
  def set_dates
    if @ransack_params.any?
      begin
        @date_from = Datet.in(@ransack_params[:date_gteq])
      rescue
        flash[:warning] = (_("Invalid date-from."))
        redirect_to :back
      end
      
      begin
        @date_to = Datet.in(@ransack_params[:date_lteq])
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
  
  def set_timelogs
    @timelogs = @ransack.result.order(:date)
    
    # Invoiced is given in a special way.
    if params[:timelog].try(:[], :invoiced) == "only_invoiced"
      @timelogs = @timelogs.where("timelogs.invoiced = '1'")
    elsif params[:timelog].try(:[], :invoiced) == "only_not_invoiced"
      @timelogs = @timelogs.where("timelogs.invoiced IS NULL")
    end
  end
  
  def timelog_params
    params.require(:timelog).permit(:task_id, :time, :time_transport, :transport_length,
      :date, :invoiced, :comment)
  end
end
