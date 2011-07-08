require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Knjtasks" do
  it "should be able to require the needed frameworks and gems" do
    require "rubygems"
    require "knjrbfw"
    require "knj/autoload"
  end
  
  it "should be able to require all the model-framework-files." do
    models_path = "#{File.dirname(__FILE__)}/../models"
    Dir.new(models_path).each do |file|
      next if file == "." or file == ".."
      fp = "#{models_path}/#{file}"
      require fp
    end
  end
  
  it "should be able to generate a sample database and start a test-environment." do
    require "rubygems"
    require "knjtasks"
    require "knjdbrevision"
    
    db_path = "#{File.dirname(__FILE__)}/../files/database_sample.sqlite3"
    #File.unlink(db_path) if File.exists?(db_path)
    
    db = Knj::Db.new(
      :type => "sqlite3",
      :path => db_path,
      :return_keys => "symbols",
      :index_append_table_name => true
    )
    
    require "#{File.dirname(__FILE__)}/../files/database_schema.rb"
    dbrev = Knjdbrevision.new
    dbrev.init_db($schema, db)
    
    tasks = Knjtasks.new(
      :host => "0.0.0.0",
      :port => 1515,
      :db => db,
      :knjjs_url => "http://www.kaspernj.org/js"
    )
    
    tasks.start
    tasks.join
  end
end
