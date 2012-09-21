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
        {"name" => "id_per_obj", "type" => "int"},
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
    "Email_check" => {
      "columns" => [
        {"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
        {"name" => "email_id_str", "type" => "varchar"}
      ],
      "indexes" => [
        {"name" => "email_id_str", "columns" => ["email_id_str"]}
      ]
    },
    "Project" => {
      "columns" => [
        {"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
        {"name" => "customer_id", "type" => "int"},
        {"name" => "name", "type" => "varchar"},
        {"name" => "descr", "type" => "text"},
        {"name" => "added_date", "type" => "datetime"},
        {"name" => "added_user_id", "type" => "int"},
        {"name" => "date_deadline", "type" => "date"}
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
        {"name" => "type", "type" => "enum", "maxlength" => "'feature','bug','question','other'"},
        {"name" => "status", "type" => "enum", "maxlength" => "'open','confirmed','waiting','closed'"},
        {"name" => "priority", "type" => "int", "default" => 1}
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
        {"name" => "invoiced", "type" => "enum", "maxlength" => "'0','1'", "default" => "0"},
        {"name" => "invoiced_date", "type" => "datetime"},
        {"name" => "invoiced_user_id", "type" => "int"}
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
        {"name" => "locale", "type" => "varchar", "maxlength" => 5, "default" => "en_GB", "comment" => "The current locale of the user which should be used for the stuff sent to him."},
        {"name" => "active", "type" => "enum", "maxlength" => "'0','1'", "default" => 1, "comment" => "If the user is active or not. This can prevent the user from logging in."}
      ],
      "on_create_after" => proc{|data|
        data["db"].insert(:User, {"username" => "admin", "passwd" => Php4r.md5("admin")})
      }
    },
    "User_project_link" => {
      "columns" => [
        {"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
        {"name" => "user_id", "type" => "int"},
        {"name" => "project_id", "type" => "int"}
      ],
      "indexes" => [
        {"name" => "user_id", "columns" => ["user_id"]},
        {"name" => "project_id", "columns" => ["project_id"]}
      ]
    },
    "User_rank" => {
      "columns" => [
        {"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
        {"name" => "id_str", "type" => "varchar"},
        {"name" => "name", "type" => "varchar"}
      ],
      "indexes" => [
        {"name" => "id_str", "columns" => ["name"]}
      ],
      "rows" => [
        {
          "find_by" => {"id" => 1},
          "data" => {"id" => 1, "id_str" => "admin", "name" => "Administrator"}
        }
      ]
    },
    "User_rank_link" => {
      "columns" => [
        {"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
        {"name" => "user_id", "type" => "int"},
        {"name" => "rank_id", "type" => "int"}
      ],
      "indexes" => [
        {"name" => "user_id", "columns" => ["user_id"]},
        {"name" => "rank_id", "columns" => ["rank_id"]}
      ],
      "on_create_after" => proc{|data|
        data["db"].insert(:User_rank_link, {:user_id => 1, :rank_id => 1})
      }
    },
    "User_task_list_link" => {
      "columns" => [
        {"name" => "id", "type" => "int", "autoincr" => true, "primarykey" => true},
        {"name" => "user_id", "type" => "int"},
        {"name" => "task_id", "type" => "int"}
      ],
      "indexes" => ["user_id", "task_id"]
    }
  }
}