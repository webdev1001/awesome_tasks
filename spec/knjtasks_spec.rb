require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Knjtasks" do
  it "should be able to require the needed frameworks and gems" do
    require "rubygems"
    require "sqlite3"
    require "knjrbfw"
    require "knjtasks"
    Knj.gem_require(:Hayabusa)
    Knj.gem_require(:Http2)
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
    db_path = "#{Knj::Os.tmpdir}/knjtasks_spec_database_sample.sqlite3"
    File.unlink(db_path) if File.exists?(db_path)
    
    db = Knj::Db.new(
      :type => "sqlite3",
      :path => db_path,
      :return_keys => "symbols",
      :index_append_table_name => true
    )
    tasks = Knjtasks.new(
      :title => "rake_rspec",
      :host => "0.0.0.0",
      :port => 1515,
      :db => db,
      :knjjs_url => "http://www.kaspernj.org/js",
      :email_admin => "k@spernj.org",
      :email_robot => "k@spernj.org",
      :smtp_args => {
        "smtp_host" => "localhost",
        "smtp_port" => 25
      },
      :db_args => false
    )
    
    tasks.start
    $tasks = tasks
    
    #The admin-user should exists.
    user = tasks.ob.get_by(:User, "username" => "admin", "passwd" => Digest::MD5.hexdigest("admin"))
    raise "Expected admin user to exist but it didnt." if !user
    
    $http = Http2.new(:host => "localhost", :port => 1515, :follow_redirects => false)
  end
  
  it "should be able to log in" do
    res = $http.post(:url => "?show=user_login&choice=dologin", :post => {
      "texuser" => "admin",
      "texpass_md5" => Digest::MD5.hexdigest("admin"),
      "cheremember" => "on"
    })
    
    res = $http.get("?show=user_login")
    raise "Expected to be logged in but wasnt according to HTML:\n#{res.body}" if res.body.index("You are logged in as") == nil
  end
  
  it "should be able to add customers" do
    res = $http.post(:url => "?show=customer_edit&choice=dosave", :post => {
      "texname" => "Test customer"
    })
    
    if match = res.body.match(/location\.href="\?show=customer_edit&customer_id=(\d+)"/)
      $customer = $tasks.ob.get(:Customer, match[1])
    else
      raise "Expected to be redirected to the new customer but wasnt:\n#{res.body}"
    end
  end
  
  it "should be able to add projects" do
    res = $http.post(:url => "?show=project_edit&choice=dosave", :post => {
      "texname" => "Test project",
      "selcustomer" => $customer.id,
      "texdescr" => "Test project"
    })
    
    if match = res.body.match(/location\.href="\?show=project_edit&project_id=(\d+)"/)
      $project = $tasks.ob.get(:Project, match[1])
    else
      raise "Expected to be redirected to new project but wasnt:\n#{res.body}"
    end
  end
  
  it "should be able to add tasks" do
    res = $http.post(:url => "?show=task_edit&choice=dosave", :post => {
      "texname" => "Test task",
      "texdescr" => "Test description",
      "selproject" => $project.id,
      "type" => "feature"
    })
    
    if match = res.body.match(/location\.href="\?show=task_show&task_id=(\d+)"/)
      $task = $tasks.ob.get(:Task, match[1])
    else
      raise "Expected to be redirected to new task but wasnt:\n#{res.body}"
    end
  end
  
  it "should show special HTML for expired sessions" do
    res = $http.get(:url => "?show=user_login&choice=dologout")
    res = $http.get(:url => "clean.rhtml?show=task_show&task_id=#{$task.id}&choice=gettimelogs")
    
    raise "Expected message about not logged in but got this instead: '#{res.body}'." if res.body != "You are not logged in. Log in and try to view this page again."
  end
end
