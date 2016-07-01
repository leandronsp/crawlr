class MassInsert
  def initialize(domain)
    @domain = domain
  end

  def insert_assets(url, assets)
    return if assets.blank?

    values = build_assets_values_to_insert url, assets
    return if values.blank?

    sql = "INSERT INTO assets (url, page_id, domain_id, created_at,\
updated_at) VALUES #{values.join(', ')} ON CONFLICT DO NOTHING"

    ActiveRecord::Base.connection.execute sql
  end

  def insert_pages(pages)
    return if pages.blank?

    values = build_pages_values_to_insert pages
    return if values.blank?

    sql = "INSERT INTO pages (url, domain_id, created_at,\
updated_at) VALUES #{values.join(', ')} ON CONFLICT DO NOTHING"

    ActiveRecord::Base.connection.execute sql
  end

  def build_assets_values_to_insert(url, assets)
    page = Page.where(url: url, domain_id: @domain.id).first
    build_urls_to_insert(assets).map do |url|
      "('#{url}', #{page.id}, #{@domain.id}, '#{DateTime.now}', '#{DateTime.now}')"
    end
  end

  def build_pages_values_to_insert(pages)
    build_urls_to_insert(pages).map do |url|
      "('#{url}', #{@domain.id}, '#{DateTime.now}', '#{DateTime.now}')"
    end
  end

  def build_urls_to_insert(source)
    source.map do |elem|
      url_without_domain elem[:url]
    end.compact.uniq
  end

  def url_without_domain(url)
    result = url.match(/(#{@domain.url})?(.*?)(\/)?$/)[2]
    result.blank? ? '/' : result
  end
end
