class Pdf::ReportPdf < Prawn::Document
  def initialize(campaign_id, view)
    super()
    @campaign = Campaign.find(campaign_id)
    @view = view
    report_header
    move_down 20
    client_info
    move_down 40
    campaign_overview
    move_down 40
    creative_overview
    draw_spent_graph
    draw_imp_vs_clicks_graph
    draw_conversion_graph
    draw_ctr_graph
  end

  def report_header
    text "Platrorm-161 | End Report | #{@campaign.end_date.strftime("%b %d, %Y")}", size: 25, style: :bold, color: "00CC00"
  end

  def client_info
    text @campaign.name.gsub("_"," "), size: 15, style: :bold, color: "00CC00"
    stroke_horizontal_rule
    bounding_box([0, 630], :width => 140, :height => 80) do
      text "Campaign Name:", style: :bold
      text "Start Date:", style: :bold
      text "End Date:", style: :bold
      text "Media budget:", style: :bold
      text "Campaign Manager Id:", style: :bold
    end

    bounding_box([150, 630], :width => 300, :height => 80) do
      text "#{@campaign.name.gsub("_", " ")}"
      move_down 1
      text "#{@campaign.start_date}"
      move_down 1
      text "#{@campaign.end_date}"
      text "#{price(@campaign.media_budget)}"
      text "#{@campaign.campaign_manager_id}"
    end

  end

  def price(num)
    @view.number_to_currency(num)
  end
  
  def campaign_overview
    text "Campaign Overview", style: :bold, size: 15, color: "00CC00"
    stroke_horizontal_rule
    line_items(:line_item_campaign_rows)
  end

  def line_items(method)
    move_down 20
    table send(method) do
      row(0).font_style = :bold
      column(0).width = 300
      columns(1..5).align = :right
    end
  end

  def line_item_campaign_rows
    [["Campaign Name", "Imps.", "Clicks", "Ctr.", "Conv.", "Spent"]] +
    [[
      @campaign.name.gsub("_", " "),
      @campaign.reports.average(:impressions).to_i,
      @campaign.reports.average(:clicks).to_i,
      "#{@campaign.reports.average(:ctr).to_f.round(2)}%",
      @campaign.reports.average(:conversions).to_i,
      price(@campaign.reports.average(:spent))
    ]]
  end

  def creative_overview
    text "Creative Overview", style: :bold, size: 15, color: "00CC00"
    stroke_horizontal_rule
    line_items(:line_item_creative_rows)
  end

  def line_item_creative_rows
    creative_reports = @campaign.creatives.map do |creative|
      unless creative.reports.empty?
        [
          creative.name.gsub("_", " "),
          creative.reports.average(:impressions).to_i,
          creative.reports.average(:clicks).to_i,
          "#{creative.reports.average(:ctr).to_f.round(2)}%",
          creative.reports.average(:conversions).to_i,
          price(creative.reports.average(:spent))
        ]
      else
        next
      end
    end
    [["Creative Name", "Imps.", "Clicks", "Ctr.", "Conv.", "Spent"]] +
    creative_reports.compact
  end

  def draw_spent_graph
    start_new_page
    text "Spent", size: 15, style: :bold, color: "00CC00"
    spents = @campaign.reports.group(:date).average(:spent)
    fill_color "f80000"
    coord_x = 0
    spents.each do |spent|
      fill_rectangle [coord_x, spent[1]*20], 15, spent[1]*20
      coord_x += 35
    end
  end

  def draw_imp_vs_clicks_graph
    start_new_page
    text "Impressions", size: 15, style: :bold, color: "f80000"
    text "vs", size: 15, style: :bold, color: "000000"
    text "Clicks", size: 15, style: :bold, color: "00CC00"
    impressions = @campaign.reports.group(:date).average(:impressions)
    clicks = @campaign.reports.group(:date).average(:clicks)
    stroke_color "f80000"
    line_width 5
    coord_x = 0
    stroke do
      move_to 0, impressions.first[1]/100
      impressions.each do |imp|
        line_to coord_x, imp[1]/100
        coord_x += 35
      end
    end
    stroke_color "00CC00"
    coord_x = 0
    stroke do
      move_to 0, clicks.first[1]
      clicks.each do |click|
        line_to coord_x, click[1]
        coord_x +=35
      end
    end
  end

  def draw_conversion_graph
    start_new_page
    text "Conversions", size: 15, style: :bold, color: "00CC00"
    conversions = @campaign.reports.group(:date).average(:conversions)
    fill_color "f80000"
    coord_x = 0
    conversions.each do |conversion|
      fill_rectangle [coord_x, conversion[1]*1000], 15, conversion[1]*1000
      coord_x += 35
    end
  end

  def draw_ctr_graph
    start_new_page
    text "Ctr", size: 15, style: :bold, color: "00CC00"
    ctrs = @campaign.reports.group(:date).average(:ctr)
    fill_color "f80000"
    coord_x = 0
    ctrs.each do |ctr|
      fill_rectangle [coord_x, ctr[1]*1000], 15, ctr[1]*1000
      coord_x += 35
    end
  end
end
