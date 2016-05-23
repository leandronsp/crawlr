class Parser
  attr_reader :document

  def initialize(source, domain)
    @source = source
    @domain = domain
  end

  def parse!
    @document = Nokogiri::HTML(@source)
  end

  def pages
    result = @document.css('a').select do |link|
      looks_same_domain? link['href']
    end

    result.map do |link|
      { url: link['href'] }
    end
  end

  def assets
    links + metas + scripts
  end

  def links
    result = @document.css('link').select do |link|
      looks_like_asset? link['href']
    end

    result.map do |link|
      { url: link['href'] }
    end
  end

  def metas
    result = @document.css('meta').select do |meta|
      meta.values.any? { |value| looks_like_asset?(value) }
    end

    result.map do |meta|
      _value = meta.values.select { |value| looks_same_domain?(value) }[0]
      { url: _value }
    end
  end

  def scripts
    result = @document.css('script').select do |script|
      looks_like_asset? script['src']
    end

    result.map do |script|
      { url: script['src'] }
    end
  end

  def looks_like_asset?(value)
    value && value.match(/.*?\.(png|ico|jpg|jpeg|css|js)/).present? &&
      (value.start_with?(@domain) ||
        (!value.start_with?('//') && !value.start_with?('http')))
  end

  def looks_same_domain?(url)
    url && (url.start_with?(@domain) || url.match(/^\/[^\/].*$/).present?)
  end
end
