class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable#, :validatable
         
  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'         
  attr_accessor :login
  
  
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_hash).first
    end
  end 
  
  validates :full_name, presence: { message: "Name cannot be blank." }
  validates :username, 
    presence: { message: "Username cannot be blank." },
    uniqueness: { message: "Username already exists.", case_sensitive: false },
    format: { message: "Username is invalid.", with: /^[a-zA-Z0-9_\.]*$/, multiline: true }
  validates :email,
    presence: { message: "Email Address cannot be blank." },
    uniqueness: { message: "A User with this Email Address already exists.", case_sensitive: false }
  validates :password, 
    length: { minimum: 6, message: "Password must be at least 6 characters long.", if: :password_required? },
    confirmation: { message: "Password Confirmation doesn't match Password.", if: :password_required? }


  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def update_with_password(params, *options)
    current_password = params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = if valid_password?(current_password)
      update_attributes(params, *options)
    else
      self.assign_attributes(params, *options)
      self.valid?
      self.errors.add(:current_password, "Current Password is Incorrect.")
      false
    end

    clean_up_passwords
    result
  end

  ######################################################
  ######################################################
  ######################################################
  
  has_many :teams, class_name: 'MyFifa::Team'
  has_many :formations, class_name: 'MyFifa::Formation'

  belongs_to :default_team, class_name: 'MyFifa::Team', foreign_key: :team_id
  belongs_to :default_formation, class_name: 'MyFifa::Formation', foreign_key: :formation_id

  after_commit :create_defaults, on: [:create]

  def create_defaults
    team = self.create_default_team(
      user_id: self.id,
      team_name: 'Default Team',
      current_date: Time.now.beginning_of_year + 6.months,
      competitions: [ 'Default Competition' ])
    formation = self.create_default_formation(
      user_id: self.id,
      title: 'Default',
      layout: '4-2-3-1',
      pos_1:  'GK',
      pos_2:  'LB',
      pos_3:  'LCB',
      pos_4:  'RCB',
      pos_5:  'RB',
      pos_6:  'LCDM',
      pos_7:  'RDM',
      pos_8:  'LAM',
      pos_9:  'CAM',
      pos_10: 'RAM',
      pos_11: 'ST',
    )
    self.update_columns(
      team_id: team.id,
      formation_id: formation.id
    )
  end
end
