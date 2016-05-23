class PersistPages
  def bulk_insert(pages)
    pages.each do |hash|
      unless Page.exists?(url: hash[:url])
        Page.create url: hash[:url]
      end
    end
  end
end
