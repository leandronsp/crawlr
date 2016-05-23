class PersistAssets
  def insert_assets_for(url, assets)
    page = Page.where(url: url).first

    if page
      Asset.destroy_all page: page
    else
      page = Page.create url: url
    end

    assets.each do |asset|
      Asset.create url: asset[:url], page: page
    end
  end
end