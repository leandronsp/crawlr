class Parser
  attr_reader :document

  def initialize(source)
    @source = source
  end

  def parse!
    @document = Nokogiri::HTML(@source)
  end

  def pages
    result = @document.css('a').select do |link|
      link['href'].match(/^\/[^\/].*$/)
    end

    result.map do |link|
      { name: link.text, url: link['href'] }
    end
  end

  def looks_same_domain?(url)
    url.match(/^\/[^\/].*$/).present?
  end
end
