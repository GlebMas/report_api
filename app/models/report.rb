class Report < ActiveRecord::Base
  validates :campaign_id, presence: true, inclusion: {in: [2108960, 2108961, 2108962, 2109230], allow_nil: true, message: "couldn't generate report for campaign with id %{value}, only for 2108960, 2108961, 2108962, 2109230"}

  has_many :comments
  belongs_to :creative
  belongs_to :campaign
end
