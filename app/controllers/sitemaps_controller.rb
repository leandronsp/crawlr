class SitemapsController < ApplicationController
  def new; end

  def generate
    url = params[:domain].match(/^(.*?)(\/)?$/)[1]

    if !url.start_with?('http')
      url = "http://#{url}"
    end

    domain = Domain.where(url: url).first
    domain ||= Domain.create url: url

    Sitemap.new(domain).generate!
    @pages = domain.reload.pages

    render json: { pages: @pages.map { |p| PageSerializer.new(p).as_json }}
  end
end
