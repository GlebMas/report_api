class ReportHistorySerializer < ActiveModel::Serializer
  attributes  :campaign_id, :date
  has_many :comments
end
