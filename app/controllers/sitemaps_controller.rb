class SitemapsController < ApplicationController
  def new; end

  def generate
    domain = Domain.where(url: params[:domain]).first
    domain ||= Domain.create url: params[:domain]

    response = RestClient.get(domain.root_page.full_url)
    parser   = Parser.new(response, domain)

    parser.parse!

    PersistPages.new(domain).bulk_insert(parser.pages)
    PersistAssets.new(domain).insert_assets_for(domain.root_page.url, parser.assets)

    @pages = domain.reload.pages.map do |page|
      response = RestClient.get(page.full_url)
      _parser  = Parser.new(response, domain)
      _parser.parse!

      PersistPages.new(domain).bulk_insert(_parser.pages)
      PersistAssets.new(domain).insert_assets_for(page.url, _parser.assets)

      page
    end

    render :sitemap
  end
end
