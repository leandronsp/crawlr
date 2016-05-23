class PersistPages
  def initialize(domain)
    @domain = domain
  end

  def bulk_insert(pages)
    pages.each do |hash|
      url = url_without_domain hash[:url]
      unless Page.exists?(url: url, domain_id: @domain.id)
        Page.create url: url, domain: @domain
      end
    end
  end

  def url_without_domain(url)
    url.match(/(#{@domain.url})?(.*)$/)[2]
  end
end
