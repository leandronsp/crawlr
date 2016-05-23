class PersistAssets
  def initialize(domain)
    @domain = domain
  end

  def insert_assets_for(url, assets)
    page = Page.where(url: url, domain_id: @domain.id).first

    if page
      Asset.destroy_all page: page
    else
      page = Page.create url: url, domain: @domain
    end

    assets.each do |asset|
      Asset.create url: asset[:url], page: page
    end
  end
end
