class PersistPages
  def initialize(domain)
    @domain = domain
  end

  def bulk_insert(pages)
    pages.each do |hash|
      unless Page.exists?(url: hash[:url], domain_id: @domain.id)
        Page.create url: hash[:url], domain: @domain
      end
    end
  end
end
