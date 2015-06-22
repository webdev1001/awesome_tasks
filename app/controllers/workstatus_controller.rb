class WorkstatusController < ApplicationController
  def index
    @ransack_params = params[:q] || {}
    @ransack = Timelog.ransack(@ransack_params)

    @timelogs = @ransack.result.includes(task: :project)
    @timelogs = @timelogs.accessible_by(current_ability)

    set_dates
    calculate_totals
  end

private

  helper_method :each_date_in_month_and_year
  def each_date_in_month_and_year(month, year)
    cur_date = @date_from.to_time.change(month: month, day: 1, year: year)
    end_of_month = cur_date.end_of_month

    while cur_date <= @date_to.to_time && cur_date <= end_of_month do
      yield cur_date
      cur_date += 1.day
    end
  end

  helper_method :each_year
  def each_year
    cur_date = @date_from.to_time

    while cur_date <= @date_to.to_time do
      yield cur_date.year
      cur_date += 1.year
    end
  end

  helper_method :each_month_in_year
  def each_month_in_year(year)
    cur_date = @date_from.to_time
    cur_date = cur_date.change(year: year)
    cur_date = Date.new.change(year: year, day: 1, month: 1) if cur_date > @date_from.to_time

    while cur_date <= @date_to.to_time do
      yield cur_date.month
      cur_date += 1.month
    end
  end

  def set_dates
    @date_from = Time.zone.parse(@ransack_params[:date_gteq]) if @ransack_params[:date_gteq]
    @date_to = Time.zone.parse(@ransack_params[:date_lteq]) if @ransack_params[:date_lteq]

    unless @date_from
      @date_from = Time.zone.now.beginning_of_month
      @timelogs = @timelogs.where("timelogs.date >= ?", @date_from)
    end

    unless @date_to
      @date_to = Time.zone.now.end_of_month
      @timelogs = @timelogs.where("timelogs.date <= ?", @date_to)
    end
  end

  def calculate_totals
    @hours = @timelogs.sum("TIME_TO_SEC(timelogs.time)") / 3600.0
    @hours_transport = @timelogs.sum("TIME_TO_SEC(timelogs.time_transport)") / 3600.0
    @earned = @timelogs.sum("TIME_TO_SEC(timelogs.time) * projects.price_per_hour") / 3600.0
    @earned_transport = @timelogs.sum("TIME_TO_SEC(timelogs.time_transport) * projects.price_per_hour_transport") / 3600.0
    @earned_total = @earned + @earned_transport
    @transport_length = @timelogs.sum(:transport_length)
    @hours_total = @hours + @hours_transport
    @tax_40 = @earned_total * 0.4
  end
end
