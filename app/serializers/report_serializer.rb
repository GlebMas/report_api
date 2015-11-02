class ReportSerializer < ActiveModel::Serializer
  attributes :campaign_name, :start_date, :end_date, :media_budget, :impressions, :clicks, :ctr, :spent

  def campaign_name
    object.campaign.name
  end

  def start_date
    object.campaign.start_date
  end

  def end_date
    object.campaign.end_date
  end

  def media_budget
    object.campaign.media_budget
  end
end
