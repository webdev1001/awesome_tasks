module TimelogHelper
  def link_to_timelog(timelog)
    if can? :edit, timelog
      link_to timelog.id, "javascript: timelog_edit('#{timelog.id}');"
    else
      timelog.id
    end
  end
end
