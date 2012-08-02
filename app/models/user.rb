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
  :first_name, :last_name, :birth_date, :avatar

  devise :omniauthable
  
  has_many :videos
  
  has_many :questions

  acts_as_voter
  
  has_many :video_view
  
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
    user = User.create(name:auth.extra.raw_info.name,
                  provider:auth.provider,
                  uid:auth.uid,
                  email:auth.info.email,
                  password:Devise.friendly_token[0,20],
                  first_name:auth.info.first_name,
                  last_name:auth.info.last_name
                )
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
end
