class ReportsController < ApplicationController
  before_action :authenticate

  def new
    @report = Report.new
  end

  def create
    @report = Report.new(report_params)

    respond_to do |format|
      if @report.valid? && find_or_create
        format.json { render json: { campaign_id: @report.campaign_id }, status: :created }
      else
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @reports = Report.includes(:comments).all
  end

  def show
    campaign_id = Campaign.find(:params[:campaign_id])

    respond_to do |format|
      format.pdf do
        pdf = Pdf::ReportPdf.new(campaign_id)
        send_date pdf.render, filename: "status_report_#{campaign_id}",
                              type: "application/pdf"
      end
    end
  end

  private

  def report_params
    params.require(:report).permit(:campaign_id)
  end

  def create_reports
    data = {
      "advertiser_report": {
        "interval": "daily",
        "date_limit": "none",
        "groupings": ["creative", "campaign"],
        "measures": ["impressions", "clicks", "conversions", "ctr", "campaign_cost"]
      }
    }

    platform161 = Api::Platform161.new(data, current_user.token)
    begin
      results = platform161.advertiser_reports["results"]
    rescue Exception
      @report.errors.add(:campaign_id, "Please, try again")
      campaign = Campaign.find(@report.campaign_id);
      campaign.destroy
      return false
    end

    reports = results.select{|result| result["campaign_id"] == @report.campaign_id}

    reports.each do |report|
      Report.create(
        date: report["date"],
        impressions: report["impressions"],
        clicks: report["clicks"],
        ctr: report["ctr"],
        spent: report["campaign_cost"],
        conversions: report["conversions"],
        creative_id: report["creative_id"],
        campaign_id: report["campaign_id"]
      )
    end

    true
  end

  def create_campaign
    platform161 = Api::Platform161.new("", current_user.token)
    result = platform161.campaigns(@report.campaign_id)

    Campaign.create(
      id: @report.campaign_id,
      name: result["name"],
      start_date: result["start_on"],
      end_date: result["end_on"],
      media_budget: result["media_budget"],
      campaign_manager_id: result["campaign_manager_id"]
    )

    true
  end

  def create_creative
    platform161 = Api::Platform161.new("", current_user.token)
    results = platform161.creatives(@report.campaign_id)

    results.each do |result|
      Creative.create(
        creative_number: result["id"],
        name: result["name"],
        campaign_id: @report.campaign_id
      )
    end

    true
  end

  def find_or_create
    begin
      campaign = Campaign.find(@report.campaign_id)

    rescue Exception
      create_campaign && create_creative && create_reports
    else
      true
    end
  end
end
