# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  username               :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  full_name              :string           default("")
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  team_id                :integer
#  formation_id           :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where('lower(username) = ? OR lower(email) = ?', login.downcase, login.downcase).first
    elsif conditions.key?(:username) || conditions.key?(:email)
      where(conditions.to_hash).first
    end
  end

  validates :full_name, presence: { message: 'Name cannot be blank.' }
  validates :username,
            presence: {
              message: 'Username cannot be blank.'
            },
            uniqueness: {
              message: 'Username already exists.',
              case_sensitive: false
            },
            format: {
              message: 'Username is invalid.',
              with: /\A[a-zA-Z0-9_\.]*\z/,
              multiline: true
            }
  validates :email,
            presence: {
              message: 'Email Address cannot be blank.'
            },
            uniqueness: {
              message: 'A User with this Email Address already exists.',
              case_sensitive: false
            }
  validates :password,
            length: {
              minimum: 6,
              message: 'Password must be at least 6 characters long.',
              if: :password_required?
            },
            confirmation: {
              message: 'Password Confirmation doesn\'t match Password.',
              if: :password_required?
            }

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def update_with_password(params, *options)
    current_password = params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result =
      if valid_password?(current_password)
        update_attributes(params, *options)
      else
        assign_attributes(params, *options)
        valid?
        errors.add(:current_password, 'Current Password is Incorrect.')
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

  belongs_to :default_team,
             class_name: 'MyFifa::Team',
             foreign_key: :team_id
  belongs_to :default_formation,
             class_name: 'MyFifa::Formation',
             foreign_key: :formation_id

  after_commit :create_defaults, on: [:create]

  def create_defaults
    team = create_default_team(
      user_id: id,
      team_name: 'Default Team',
      current_date: Time.now.beginning_of_year + 6.months
    )
    formation = create_default_formation(
      user_id: id,
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
      pos_11: 'ST'
    )
    update_columns(
      team_id: team.id,
      formation_id: formation.id
    )
  end
end
