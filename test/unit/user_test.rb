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

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
