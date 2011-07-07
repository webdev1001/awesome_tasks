$schema = {
  "tables" => {
    "Project" => {
      "columns" => [
        {"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
        {"name" => "name", "type" => "varchar"}
      ]
    },
    "Task" => {
      "columns" => [
        {"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
        {"name" => "project_id", "type" => "int"},
        {"name" => "name", "type" => "varchar"},
        {"name" => "descr", "type" => "text"}
      ],
      "indexes" => [
        {"name" => "project_id", "columns" => ["project_id"]}
      ]
    },
    "Timelog" => {
      "columns" => [
        {"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
        {"name" => "task_id", "type" => "int"},
        {"name" => "user_id", "type" => "int"}
      ],
      "indexes" => [
        {"name" => "task_id", "columns" => ["task_id"]},
        {"name" => "user_id", "columns" => ["user_id"]}
      ]
    },
    "User" => {
      "columns" => [
        {"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
        {"name" => "name", "type" => "varchar"},
        {"name" => "username", "type" => "varchar"},
        {"name" => "passwd", "type" => "varchar"},
        {"name" => "email", "type" => "varchar"}
      ],
      "on_create_after" => proc{|data|
        data["db"].insert(:User, {"username" => "admin", "passwd" => Knj::Php.md5("admin")})
      }
    }
  }
}