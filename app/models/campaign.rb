class Campaign < ActiveRecord::Base
  has_many :reports, dependent: :delete_all
  has_many :creatives, dependent: :delete_all
end
