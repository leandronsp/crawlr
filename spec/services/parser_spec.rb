describe Parser do

  let(:source) { File.read('spec/fixtures/home.html') }
  subject { Parser.new(source, 'http://mysample.com') }

  describe '#parse!' do
    it 'parses the source and stores the document in an attribute' do
      subject.parse!
      expect(subject.document.class).to eq Nokogiri::HTML::Document
    end
  end

  describe '#pages' do
    before { subject.parse! }

    it 'returns all pages within the same domain' do
      pages = [
        { name: 'Page 1', url: '/page-1' },
        { name: 'Page 2', url: '/page-2' },
        { name: 'Page 3', url: '/page-3' },
        { name: 'Page 5', url: '/page-5/' },
        { name: 'Page 6', url: '/page-6/new/' }
      ]

      expect(subject.pages).to eq(pages)
    end
  end

  describe '#assets' do
    before { subject.parse! }

    it 'returns all assets links within the page' do
      assets = [
        { url: '/home.css' },
        { url: '/images/apple-icon.png' },
        { url: '/images/icon.png' },
        { url: '/images/logo.png' },
        { url: 'http://mysample.com/yetanother.png' },
        { url: '/home.js' },
        { url: 'another.js' },
        { url: '/body-script.js' }
      ]

      expect(subject.assets).to eq(assets)
    end
  end

  describe '#looks_same_domain?' do
    it 'checks if link/url looks within same domain' do
      expect(subject.looks_same_domain?('/page-1')).to be_truthy
      expect(subject.looks_same_domain?('/page-2/')).to be_truthy
      expect(subject.looks_same_domain?('/page-3/nested/')).to be_truthy
      expect(subject.looks_same_domain?('http://external.com/page-1')).to be_falsy
      expect(subject.looks_same_domain?('//cdn.could.com/page-1')).to be_falsy
    end
  end

  describe '#looks_like_asset?' do
    it 'checks if link looks an asset within same domain' do
      expect(subject.looks_like_asset?('another.js')).to be_truthy
      expect(subject.looks_like_asset?('/body.js')).to be_truthy
      expect(subject.looks_like_asset?('/home/home.css')).to be_truthy
      expect(subject.looks_like_asset?('http://mysample.com/1/home.ico')).to be_truthy

      expect(subject.looks_like_asset?('http://external.com/home.css')).to be_falsy
      expect(subject.looks_like_asset?('//cdn.could.com/body.js')).to be_falsy
    end
  end

end
