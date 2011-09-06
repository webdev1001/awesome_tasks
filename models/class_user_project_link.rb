class Knjtasks::User_project_link < Knj::Datarow
  has_one [
    :User,
    :Project
  ]
end