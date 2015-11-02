class Api::ReportsController < Api::ApplicationController
  def show
    begin
      campaign = Campaign.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {message: "Campaign with that id doesn't exist"}
    else
      @campaign_reports = campaign.reports
      render json: @campaign_reports
    end
  end

  def index
    @reports = Report.all
    render json: @reports, each_serializer: ReportHistorySerializer
  end
end
