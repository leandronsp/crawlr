class SitemapsController < ApplicationController
  def new; end

  def generate
    domain = Domain.where(url: params[:domain]).first

    if domain
      domain.reset!
    else
      domain = Domain.create url: params[:domain]
    end

    visit_links(domain)
    @pages = domain.reload.pages

    render json: { pages: @pages.map { |p| PageSerializer.new(p).as_json }}
  end

  private

  def visit_links(domain)
    ActiveRecord::Base.logger = nil
    pages = domain.reload.pages.where(visited: false)
    return if pages.count == 0

    future_responses = pages.map do |page|
      page.update_attributes visited: true

      Celluloid::Future.new do
        [RestClient::Request.execute({
          method: :get,
          url: page.full_url,
          timeout: 5,
          open_timeout: 5
        }), page]
      end
    end

    future_responses.each do |future|
      begin
        response, page = future.value
        parser = Parser.new(response, domain)
        parser.parse!

        mass_insert = MassInsert.new(domain)
        mass_insert.insert_pages parser.pages
        mass_insert.insert_assets page.url, parser.assets

        parser      = nil
        response    = nil
        mass_insert = nil
      rescue => e
        Rails.logger.error e
      end
    end

    return visit_links(domain)
  end
end
