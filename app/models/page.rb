class Page < ActiveRecord::Base
  belongs_to :domain
  has_many :assets

  validates_presence_of :url, :domain

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
