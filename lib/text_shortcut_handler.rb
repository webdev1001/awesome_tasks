class TextShortcutHandler
  attr_reader :text

  def initialize(args)
    @text = args[:text]

    if args[:host]
      @host = args[:host]
    elsif args[:request]
      @host = args[:request].host_with_port
    end
  end

  def replace_task_tags_with_links
    task_tags do |data|
      @text = @text.gsub(data[:text_found], "<a href=\"http://#{@host}/tasks/#{data[:task].id}\">#{Knj::Web.html(data[:task].name.truncate(30))}</a>")
    end

    return self
  end

  def replace_task_tags_with_text
    task_tags do |data|
      @text = @text.gsub(data[:text_found], data[:task].name)
    end

    return self
  end

  def replace_timelog_tags_with_links
    timelog_tags do |data|
      @text = @text.gsub(data[:text_found], "<a href=\"http://#{@host}/tasks/#{data[:timelog].task_id}#timelog-#{data[:timelog].id}\">#{Knj::Web.html(Timelog.model_name.human)} #{data[:timelog].id}</a>")
    end

    return self
  end

  def replace_timelog_tags_with_text
    timelog_tags do |data|
      @text = @text.gsub(data[:text_found], "Timelog #{data[:timelog].id}")
    end

    return self
  end

  def self.as_html(*args, &blk)
    new(*args, &blk)
      .replace_task_tags_with_links
      .replace_timelog_tags_with_links
      .text
      .html_safe
  end

  def self.as_text(*args, &blk)
    new(*args, &blk)
      .replace_task_tags_with_text
      .replace_timelog_tags_with_text
      .text
  end

private

  def task_tags
    @text.scan(/(\[task:(\d+)\])/) do |match|
      task = Task.where(id: match[1]).first
      next unless task

      yield text_found: match[0], task: task
    end
  end

  def timelog_tags
    @text.scan(/(\[timelog:(\d+)\])/) do |match|
      timelog = Timelog.where(id: match[1]).first
      next unless timelog

      yield text_found: match[0], timelog: timelog
    end
  end
end
