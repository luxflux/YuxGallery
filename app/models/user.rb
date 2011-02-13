class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :nickname, :password, :password_confirmation, :remember_me

  validates_uniqueness_of :nickname
  validates_presence_of   :nickname

  has_many :albums
  has_many :photos, :through => :albums

  has_friendly_id :nickname, :use_slug => true

  def random_photo
    self.photos.shuffle.first
  end

  def title
    self.nickname
  end

end
