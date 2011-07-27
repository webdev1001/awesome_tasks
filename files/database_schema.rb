$schema = {
  "tables" => {
    "Customer" => {
      "columns" => [
        {"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
        {"name" => "name", "type" => "varchar"},
        {"name" => "date_added", "type" => "datetime"}
      ]
    },
    "Comment" => {
      "columns" => [
        {"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
        {"name" => "object_class", "type" => "varchar"},
        {"name" => "object_id", "type" => "int"},
        {"name" => "user_id", "type" => "int"},
        {"name" => "date_saved", "type" => "datetime"},
        {"name" => "comment", "type" => "text"}
      ],
      "indexes" => [
        {"name" => "object_lookup", "columns" => ["object_class", "object_id"]},
        {"name" => "user_id", "columns" => ["user_id"]}
      ]
    },
    "Project" => {
      "columns" => [
        {"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
        {"name" => "customer_id", "type" => "int"},
        {"name" => "name", "type" => "varchar"},
        {"name" => "descr", "type" => "text"},
        {"name" => "added_date", "type" => "datetime"},
        {"name" => "added_user_id", "type" => "int"}
      ],
      "indexes" => [
        {"name" => "customer_id", "columns" => ["customer_id"]},
        {"name" => "added_user_id", "columns" => ["added_user_id"]}
      ]
    },
    "Task" => {
      "columns" => [
        {"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
        {"name" => "project_id", "type" => "int"},
        {"name" => "user_id", "type" => "int"},
        {"name" => "date_added", "type" => "datetime"},
        {"name" => "name", "type" => "varchar"},
        {"name" => "descr", "type" => "text"},
        {"name" => "type", "type" => "enum", "maxlength" => "'feature','bug','question'"},
        {"name" => "status", "type" => "enum", "maxlength" => "'open','confirmed','waiting','closed'"}
      ],
      "indexes" => [
        {"name" => "project_id", "columns" => ["project_id"]},
        {"name" => "user_id", "columns" => ["user_id"]}
      ]
    },
    "Task_check" => {
      "columns" => [
        {"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
        {"name" => "task_id", "type" => "int"},
        {"name" => "added_user_id", "type" => "int"},
        {"name" => "date_added", "type" => "datetime"},
        {"name" => "name", "type" => "varchar"},
        {"name" => "descr", "type" => "text"},
        {"name" => "checked", "type" => "enum", "maxlength" => "'0','1'", "default" => 0},
      ],
      "indexes" => [
        {"name" => "task_id", "columns" => ["task_id"]}
      ]
    },
    "Task_assigned_user" => {
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
    "Timelog" => {
      "columns" => [
        {"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
        {"name" => "task_id", "type" => "int"},
        {"name" => "user_id", "type" => "int"},
        {"name" => "date", "type" => "date"},
        {"name" => "time", "type" => "time"},
        {"name" => "time_transport", "type" => "time"},
        {"name" => "transport_length", "type" => "int"},
        {"name" => "comment", "type" => "text"},
        {"name" => "invoiced", "type" => "enum", "maxlength" => "'0','1'", "default" => "0"}
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
        {"name" => "email", "type" => "varchar"},
        {"name" => "locale", "type" => "varchar", "maxlength" => 5, "default" => "en_GB", "comment" => "The current locale of the user which should be used for the stuff sent to him."}
      ],
      "on_create_after" => proc{|data|
        data["db"].insert(:User, {"username" => "admin", "passwd" => Knj::Php.md5("admin")})
      }
    }
  }
}