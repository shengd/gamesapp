# == Schema Information
#
# Table name: users
#
#  id          :integer(4)      not null, primary key
#  login       :string(255)
#  email       :string(255)
#  hashed_pswd :string(255)
#  salt        :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class User < ActiveRecord::Base
  attr_accessible :login, :email, :password, :password_confirmation
  has_secure_password

  validates :login, presence: true,
                    length: { minimum: 4, maximum: 20 },
                    uniqueness: { case_sensitive: false }

  # Email regex by Arluison Guillaume (http://www.mi-ange.net/)
  EMAIL_REGEX = /\A[-a-z0-9~!$%^&*_=+}{\'?]+(\.[-a-z0-9~!$%^&*_=+}{\'?]+)*@([a-z0-9_][-a-z0-9_]*(\.[-a-z0-9_]+)*\.(aero|arpa|biz|com|coop|edu|gov|info|int|mil|museum|name|net|org|pro|travel|mobi|[a-z][a-z])|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?\z/i 
  validates :email, presence: true,
                    format: { with: EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  has_many :games
end
