describe 'crawling a domain' do
  let(:domain)       { Domain.create(url: 'http://mysample.com') }
  let(:mass_insert)  { MassInsert.new(domain)  }

  let(:parser) do
    source = File.read('spec/fixtures/home.html')
    Parser.new(source, domain)
  end

  before { parser.parse! }

  it 'has 6 pages including the domain root' do
    mass_insert.insert_pages parser.pages
    expect(domain.pages.count).to eq(6)
    expect(domain.pages.first.url).to eq('/')
  end

  describe 'pages' do
    it 'craws all pages and saves them into database' do
      mass_insert.insert_pages parser.pages
      expect(Page.count).to eq(6)
    end

    it 'does not save an existent page' do
      Page.create url: '/my-url', domain: domain
      mass_insert.insert_pages [{ url: '/my-url' }]
      expect(Page.where(url: '/my-url').count).to eq(1)
    end

    it 'removes domain from page url before inserting' do
      mass_insert.insert_pages [{ url: 'http://mysample.com/my-url' }]
      expect(Page.where(url: '/my-url').count).to eq(1)
    end

    it 'does not duplicate existent pages' do
      mass_insert.insert_pages parser.pages
      expect(Page.count).to eq(6)

      new_page = { url: '/new-page' }
      mass_insert.insert_pages parser.pages + [new_page]
      expect(Page.count).to eq(7)
    end

  end

  describe 'assets' do
    it 'inserts all assets for the page' do
      page = Page.create url: '/my-url', domain: domain
      mass_insert.insert_assets '/my-url', parser.assets

      expect(Asset.count).to eq(8)
      expect(page.reload.assets.count).to eq(8)
    end
  end
end
