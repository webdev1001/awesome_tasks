module TimelogHelper
  def link_to_timelog(timelog)
    if can?(:edit, timelog)
      if agent_mobile?
        link_to timelog.id, timelog
      else
        link_to timelog.id, "javascript: timelog_edit('#{timelog.id}');"
      end
    else
      timelog.id
    end
  end
end
