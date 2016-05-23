class Asset < ActiveRecord::Base
  belongs_to :page

  def domain
    page.domain
  end

  def full_url
    return domain.url if url == '/'
    return url if url.starts_with?(domain.url)

    if url.start_with?('/')
      domain.url + url
    else
      domain.url + '/' + url
    end
  end
end
