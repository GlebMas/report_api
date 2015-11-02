class Api::Platform161
  include HTTParty
  base_uri "https://testcost.platform161.com/api/v2"

  def initialize(parameters, token = nil)
    @options = {query: parameters}

    unless token.nil?
      @options[:headers] = {"PFM161-API-AccessToken" => token}
    end
  end

  def access_tokens
    self.class.post("/access_tokens", @options)
  end

  def advertiser_reports
    self.class.post("/advertiser_reports", @options)
  end

  def campaigns(id)
    self.class.get("/campaigns/#{id}", @options)
  end

  def creatives(campaign_id)
    self.class.get("/campaigns/#{campaign_id}/creatives", @options)
  end
end
