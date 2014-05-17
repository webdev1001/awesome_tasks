module TimelogHelper
  def link_to_timelog(timelog)
    link_to timelog.id, "javascript: timelog_edit('#{timelog.id}');"
  end
end
