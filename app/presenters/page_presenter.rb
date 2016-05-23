class PagePresenter
  def initialize(page)
    @page = page
  end

  def url
    if @page.url.start_with?('/')
      @page.domain.url + @page.url
    else
      @page.domain.url + '/' + @page.url
    end
  end

  def assets
    @page.assets
  end
end
