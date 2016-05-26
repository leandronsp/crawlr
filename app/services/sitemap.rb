class Sitemap
  def initialize(domain)
    @domain = domain
    @domain.reset!

    @mass_insert = MassInsert.new(domain)
  end

  def generate!
    pages = @domain.reload.pages.where(visited: false)
    return if pages.count == 0

    async_responses(pages).each do |future|
      begin
        response, page = future.value
        parser = Parser.new(response, @domain)
        parser.parse!

        page.update_attributes title: parser.title
        @mass_insert.insert_pages parser.pages
        @mass_insert.insert_assets page.url, parser.assets
      rescue => e
        Rails.logger.error e
      end
    end

    return generate!
  end

  private

  def async_responses(pages)
    pages.map do |page|
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
  end

end
