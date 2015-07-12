require "spec_helper"

describe TextShortcutHandler do
  let!(:task) { create :task }
  let!(:timelog) { create :timelog, task: task }

  it "#replace_task_tags_with_links" do
    text = "asd [task:#{task.id}] asd"
    handler = TextShortcutHandler.new(text: text, host: "test.host")
    handler.replace_task_tags_with_links.text.should eq "asd <a href=\"http://test.host/tasks/#{task.id}\">#{task.name}</a> asd"
  end

  it "#replace_task_tags_with_text" do
    text = "asd [task:#{task.id}] asd"
    handler = TextShortcutHandler.new(text: text, host: "test.host")
    handler.replace_task_tags_with_text.text.should eq "asd #{task.name} asd"
  end

  it "#replace_timelog_tags_with_links" do
    text = "asd [timelog:#{timelog.id}] asd"
    handler = TextShortcutHandler.new(text: text, host: "test.host")
    handler.replace_timelog_tags_with_links.text.should eq "asd <a href=\"http://test.host/tasks/#{task.id}#timelog-#{timelog.id}\">Timelog #{timelog.id}</a> asd"
  end

  it "#replace_timelog_tags_with_text" do
    text = "asd [timelog:#{timelog.id}] asd"
    handler = TextShortcutHandler.new(text: text, host: "test.host")
    handler.replace_timelog_tags_with_text.text.should eq "asd Timelog #{timelog.id} asd"
  end
end
