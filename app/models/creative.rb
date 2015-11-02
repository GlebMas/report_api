class Creative < ActiveRecord::Base
  has_many :reports, primary_key: :creative_number
  belongs_to :campaign
end
