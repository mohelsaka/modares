class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable
  
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" },
                             :default_url => "Icon-user.png"

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider, :uid,
  :first_name, :last_name, :birth_date, :avatar, :avatar_file_name

  devise :omniauthable
  
  has_many :videos
  
  has_many :questions

  has_many :answers
  
  #-------------- 
  has_reputation :points,
      :source => [
          { :reputation => :votes, :of => :questions, :weight => 1 },
          { :reputation => :votes, :of => :answers, :weight => 2 },
          { :reputation => :votes, :of => :videos, :weight => 3 }],
      :aggregated_by => :sum

  has_reputation :questioning_skill,
      :source => { :reputation => :votes, :of => :questions },
      :aggregated_by => :sum

  has_reputation :answering_skill,
      :source => { :reputation => :votes, :of => :answers },
      :aggregated_by => :sum
      
  has_reputation :teaching_skill,
      :source => { :reputation => :votes, :of => :videos },
      :aggregated_by => :sum
        
      
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    # puts auth.extra.raw_info.birthday.class
    # request.env['omniauth.auth'] = auth
    # debugger
    unless user
      user = User.create(
                    birth_date:Date.strptime(auth.extra.raw_info.birthday, '%m/%d/%Y'),
                    provider:auth.provider,
                    uid:auth.uid,
                    email:auth.info.email,
                    avatar_file_name:auth.info.image,
                    password:Devise.friendly_token[0,20],
                    first_name:auth.info.first_name,
                    last_name:auth.info.last_name
                  )
    puts user.birth_date 
    end
    
    user
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  
  def name
    n = [first_name,last_name].select{|x| !x.blank?}.join(" ")
    n.blank? ? email : n
  end
  
  def age
    now = Time.now.utc.to_date
    now.year - birth_date.year - (birth_date.to_date.change(:year => now.year) > now ? 1 : 0)
  end
  
  # returns the vote value for object which was voted by this user
  # or nil if he hasn't voted for this object before
  def vote_for(object)
    RSEvaluation.where(:target_type => object.class.name,
                        :target_id => object.id,
                        :source_id => self.id,
                        :source_type => self.class.name).first.try(:value)
  end
  
  def can_vote_for?(object)
    object.user != self
  end
  def image
    if provider == "facebook"
      avatar_file_name
    else
      avatar.url(:medium)
    end
  end
  
end
