class PagePresenter
  def initialize(hash, opts = {})
    @hash   = hash
    @opts   = opts
    @domain = opts[:domain] || ""
  end

  def url
    if @hash[:url].start_with?('/')
      @domain + @hash[:url]
    else
      @domain + "/#{@hash[:url]}"
    end
  end
end
