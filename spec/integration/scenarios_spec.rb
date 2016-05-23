describe 'crawling a domain' do
  let(:domain)                 { Domain.create(url: 'http://mysample.com') }
  let(:persist_pages_service)  { PersistPages.new(domain)  }
  let(:persist_assets_service) { PersistAssets.new(domain) }

  let(:parser) do
    source = File.read('spec/fixtures/home.html')
    Parser.new(source, domain)
  end

  before { parser.parse! }

  it 'has 6 pages including the domain root' do
    persist_pages_service.bulk_insert parser.pages
    expect(domain.pages.count).to eq(6)
    expect(domain.pages.first.url).to eq('/')
  end

  describe 'pages' do
    it 'craws all pages and saves them into database' do
      persist_pages_service.bulk_insert parser.pages
      expect(Page.count).to eq(6)
    end

    it 'does not save an existent page' do
      Page.create url: '/my-url', domain: domain
      persist_pages_service.bulk_insert [{ url: '/my-url' }]
      expect(Page.where(url: '/my-url').count).to eq(1)
    end
  end

  describe 'assets' do
    it 'inserts all assets for the page' do
      page = Page.create url: '/my-url', domain: domain
      persist_assets_service.insert_assets_for '/my-url', parser.assets

      expect(Asset.count).to eq(8)
      expect(page.reload.assets.count).to eq(8)
    end

    it 'creates a new page if it does not exist' do
      persist_assets_service.insert_assets_for '/new-url', parser.assets
      expect(Page.last.url).to eq('/new-url')
    end

    it 'ensures the new collection is fresh if calling it twice' do
      Page.create url: '/my-url', domain: domain
      persist_assets_service.insert_assets_for '/my-url', parser.assets
      expect(Asset.count).to eq(8)

      # trying twice, it should destroy_all previous assets for this page
      persist_assets_service.insert_assets_for '/my-url', parser.assets
      expect(Asset.count).to eq(8)
    end
  end
end
