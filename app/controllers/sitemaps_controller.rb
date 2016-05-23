class SitemapsController < ApplicationController
  def new; end

  def generate
    @domain   = params[:domain]
    response = RestClient.get(@domain)
    parser   = Parser.new(response, @domain)

    parser.parse!

    @pages = parser.pages.map do |page|
      PagePresenter.new page, domain: @domain
    end

    @assets = parser.assets.map do |asset|
      AssetPresenter.new asset, domain: @domain
    end

    render :sitemap
  end
end
