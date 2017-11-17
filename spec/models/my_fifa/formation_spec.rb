# == Schema Information
#
# Table name: my_fifa_formations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  title      :string
#  layout     :string
#  pos_1      :string
#  pos_2      :string
#  pos_3      :string
#  pos_4      :string
#  pos_5      :string
#  pos_6      :string
#  pos_7      :string
#  pos_8      :string
#  pos_9      :string
#  pos_10     :string
#  pos_11     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe MyFifa::Formation, type: :model do
end
