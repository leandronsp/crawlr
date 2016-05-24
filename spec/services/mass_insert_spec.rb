describe MassInsert do

  let(:domain) { double('domain', id: 42, url: 'http://mysample.com') }

  subject { described_class.new(domain) }

  describe '#insert_assets' do
    let(:assets) do
      [
        { url: '/home.css' },
        { url: '/images/apple-icon.png' },
        { url: '/images/icon.png' },
        { url: '/images/logo.png' },
        { url: 'http://mysample.com/yetanother.png' },
        { url: '/home.js' },
        { url: 'another.js' },
        { url: '/body-script.js' }
      ]
    end

    let(:page) { Page.new(id: 42, url: '/page-1') }

    it 'inserts assets for the page' do
      allow(Page).to receive(:where).with(url: '/page-1', domain_id: domain.id)
                                    .and_return([page])
      allow(ActiveRecord::Base.connection).to receive(:execute)
      values = subject.build_assets_values_to_insert('/page-1', assets)
      subject.insert_assets('/page-1', assets)
      sql = "INSERT OR IGNORE INTO assets (`url`, `page_id`, `domain_id`, `created_at`,\
`updated_at`) VALUES #{values.join(', ')}"
      expect(ActiveRecord::Base.connection).to have_received(:execute).with(sql)
    end
  end

  describe '#insert_pages' do
    let(:pages) do
      [
        { url: '/page-1' },
        { url: '/page-2' },
        { url: 'http://mysample.com/page-3' },
        { url: '/page-5/' },
        { url: '/page-6/new/' }
      ]
    end

    it 'inserts assets for the page' do
      allow(ActiveRecord::Base.connection).to receive(:execute)
      values = subject.build_pages_values_to_insert(pages)
      subject.insert_pages(pages)
      sql = "INSERT OR IGNORE INTO pages (`url`, `domain_id`, `created_at`,\
`updated_at`) VALUES #{values.join(', ')}"
      expect(ActiveRecord::Base.connection).to have_received(:execute).with(sql)
    end
  end

  describe '#build_urls_to_insert' do
    it 'removes duplicated urls' do
      urls = [{ url: '/home.css' }, { url: '/home.css' }]
      expect(subject.build_urls_to_insert(urls).size).to eq(1)
    end
  end

  describe '#url_without_domain' do
    it 'removes domain from url and last slash' do
      expect(subject.url_without_domain('http://mysample.com')).to eq('/')
      expect(subject.url_without_domain('/')).to eq('/')
      expect(subject.url_without_domain('http://mysample.com/page-1')).to eq('/page-1')
      expect(subject.url_without_domain('/page-1/')).to eq('/page-1')
      expect(subject.url_without_domain('/page-1/page-5/')).to eq('/page-1/page-5')
    end
  end
end
