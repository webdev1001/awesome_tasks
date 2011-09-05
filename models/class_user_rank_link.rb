class Knjtasks::User_rank_link < Knj::Datarow
  has_one [
    :User,
    {:class => :User_rank, :col => :rank_id, :method => :rank}
  ]
  
  def self.add(d)
    user = d.ob.get(:User, d.data[:user_id])
    rank = d.ob.get(:User_rank, d.data[:rank_id])
    
    link = d.ob.get_by(:User_rank_link, {
      "user" => user,
      "rank" => rank
    })
    raise _("That user already have that rank.") if link
  end
end