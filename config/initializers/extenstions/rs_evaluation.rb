class RSEvaluation
  before_save :add_owner
  attr_accessible :target_owner
  
  def add_owner
    self.target_owner_id = target.user.id
  end    
end