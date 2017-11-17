# == Schema Information
#
# Table name: my_fifa_contract_terms
#
#  id             :integer          not null, primary key
#  contract_id    :integer
#  end_date       :date
#  wage           :integer
#  signing_bonus  :integer
#  stat_bonus     :integer
#  num_stats      :integer
#  stat_type      :string
#  release_clause :integer
#  start_date     :date
#

require 'rails_helper'

RSpec.describe MyFifa::ContractTerm, type: :model do
end
