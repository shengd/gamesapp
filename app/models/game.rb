# == Schema Information
#
# Table name: games
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  user_id    :integer(4)
#  filename   :string(255)
#  classname  :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Game < ActiveRecord::Base
  belongs_to :user
end
