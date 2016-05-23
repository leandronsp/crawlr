class PagePresenter
  def initialize(page)
    @page = page
  end

  def url
    @page.full_url
  end

  def assets
    @page.assets
  end
end
