class SitemapsController < ApplicationController
  def new; end

  def generate
    domain = Domain.create url: params[:domain]

    response = RestClient.get(domain.url)
    parser   = Parser.new(response, domain)

    parser.parse!

    PersistPages.new(domain).bulk_insert(parser.pages)

    @pages = domain.pages.map do |page|
      PagePresenter.new page
    end

    render :sitemap
  end
end
