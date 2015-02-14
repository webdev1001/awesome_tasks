class TimelogsController < ApplicationController
  load_and_authorize_resource

  def index
    @ransack_params = params[:q] || {}
    @ransack = Timelog.ransack(@ransack_params)

    @invoiced_collection = {
      _("All") => "",
      _("Only invoiced") => "only_invoiced",
      _("Only un-invoiced") => "only_not_invoiced"
    }

    @timelogs_sorted = {}

    set_dates
    set_timelogs
  end

  def new
    @timelog = Timelog.new(
      date: Time.zone.today.to_date,
      time: "00:00:00",
      time_transport: "00:00:00"
    )
    @timelog.user = current_user
    @timelog.assign_attributes(timelog_params) if params[:timelog]

    if request.xhr?
      render :new, layout: false
    end
  end

  def create
    @timelog = Timelog.new(timelog_params)
    @timelog.user = current_user

    if @timelog.save
      if request.xhr?
        render nothing: true
      else
        redirect_to @timelog.task
      end
    else
      if request.xhr?
        render text: _("Could not save: %{errors}", errors: @timelog.errors.full_messages.join(". "))
      else
        flash[:error] = @timelog.errors.full_messages.join(". ")
        render :new
      end
    end
  end

  def edit
    if request.xhr?
      render :edit, layout: false
    end
  end

  def update
    if @timelog.update_attributes(timelog_params)
      if request.xhr?
        render nothing: true
      else
        redirect_to @timelog.task
      end
    else
      if request.xhr?
        render text: _("Could not save: %{errors}", errors: @timelog.errors.full_messages.join(". "))
      else
        render :edit
      end
    end
  end

  def show
  end

  def destroy
    @timelog.destroy!

    if request.xhr?
      render nothing: true
    else
      redirect_to @timelog.task
    end
  end

  def mark_invoiced
    params["tlog_ids"].to_s.split(";").each do |timelog_id|
      next unless timelog_id.to_i > 0
      timelog = Timelog.find(timelog_id)
      timelog.invoiced = true
      timelog.save!
    end

    render nothing: true
  end

private

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
      @timelogs = @timelogs.not_invoiced
    end
  end

  def timelog_params
    params.require(:timelog).permit(:task_id, :time, :time_transport, :transport_length,
      :date, :invoiced, :comment)
  end
end
