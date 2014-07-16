class WorkstatusController < ApplicationController
  def index
    @search = params[:search] || {}

    @date_from = Datet.in(@search[:date_from]) if @search[:date_from]
    @date_to = Datet.in(@search[:date_to]) if @search[:date_to]

    unless @date_from
      @date_from = Datet.new
      @date_from.day = 1
    end

    unless @date_to
      @date_to = Datet.new
      @date_to.day = @date_to.days_in_month
    end
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
end
