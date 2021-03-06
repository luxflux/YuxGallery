# == Schema Information
# Schema version: 20110219144519
#
# Table name: users
#
#  id                   :integer         not null, primary key
#  email                :string(255)     default(""), not null
#  encrypted_password   :string(128)     default(""), not null
#  password_salt        :string(255)     default(""), not null
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :datetime
#  sign_in_count        :integer         default(0)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  nickname             :string(255)
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  
  ROLES = %w[admin user guest]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :nickname, :password, :password_confirmation, :remember_me, :role
  attr_accessor :oldnickname

  validates_uniqueness_of :nickname
  validates_presence_of   :nickname
  validates_format_of     :nickname, :with => %r{[a-zA-Z0-9]{3,}}
  validates_format_of     :nickname, :without => %r{\.{2}}
  validates_inclusion_of  :role, :in => ROLES.map { |r| r.to_sym }

  has_many :albums, :dependent => :destroy

  # friendly_id
  extend FriendlyId
  friendly_id :nickname, :use => :slugged

  after_create :create_sftp_folder
  after_save :move_sftp_folder, :if => :nickname_changed?
  after_destroy :remove_sftp_folder
  after_initialize :set_defaults

  def random_photo
    self.albums.shuffle.first.random_photo if self.albums.length > 0
  end

  def title
    self.nickname
  end

  def nickname=(value)
    @oldnickname = self[:nickname] unless new_record?
    self[:nickname] = value
  end

  def sftp_folder(old = false)
    File.join(User.sftp_base_folder, (old && @oldnickname ? @oldnickname : self.nickname))
  end

  def create_sftp_folder
    Dir.mkdir(self.sftp_folder) unless File.exists?(self.sftp_folder)
  end

  def remove_sftp_folder
    FileUtils.rm_rf(self.sftp_folder)
  end

  def move_sftp_folder
    File.rename(self.sftp_folder(true), self.sftp_folder)
  end

  def glob_sftp_folders(glob)
    glob = glob.gsub(/\.\.\//,'')
    glob_path = File.join(self.sftp_folder, "#{glob}**")
    Dir.glob(glob_path, File::FNM_CASEFOLD | File::FNM_PATHNAME).map do |entry|
      entry.gsub(Regexp.escape(self.sftp_folder), '')
    end
  end

  def self.sftp_base_folder
    folder = YuxGallery::Application.config.sftp_upload_path
    Dir.mkdir(folder) unless File.exists?(folder)
    folder
  end

  def set_defaults
    if self[:role].nil?
      self.role = :user
    end
  end

  def role
    if self[:role] && !new_record?
      self[:role].to_sym
    else
      :guest
    end
  end

  def is?(r)
    self.role == r.to_sym
  end

  ROLES.each do |r|
    define_method("#{r}?") do 
      self.is?(r)
    end
  end

end

