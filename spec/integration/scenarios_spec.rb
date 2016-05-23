describe 'crawling' do
  let(:persist_pages_service)  { PersistPages.new  }
  let(:persist_assets_service) { PersistAssets.new }

  let(:parser) do
    source = File.read('spec/fixtures/home.html')
    Parser.new(source, 'http://mysample.com')
  end

  before { parser.parse! }

  describe 'pages' do
    it 'craws all pages and saving them into database' do
      persist_pages_service.bulk_insert parser.pages
      expect(Page.count).to eq(5)
    end

    it 'does not save an existent page' do
      Page.create url: '/my-url'
      persist_pages_service.bulk_insert [{ url: '/my-url' }]
      expect(Page.count).to eq(1)
    end
  end

  describe 'assets' do
    it 'inserts all assets for the page' do
      page = Page.create url: '/my-url'
      persist_assets_service.insert_assets_for '/my-url', parser.assets

      expect(Asset.count).to eq(8)
      expect(page.reload.assets.count).to eq(8)
    end

    it 'creates a new page if it does not exist' do
      persist_assets_service.insert_assets_for '/new-url', parser.assets
      expect(Page.last.url).to eq('/new-url')
    end

    it 'ensures the new collection is fresh if calling it twice' do
      Page.create url: '/my-url'
      persist_assets_service.insert_assets_for '/my-url', parser.assets
      expect(Asset.count).to eq(8)

      # trying twice, it should destroy_all previous assets for this page
      persist_assets_service.insert_assets_for '/my-url', parser.assets
      expect(Asset.count).to eq(8)
    end
  end
end
