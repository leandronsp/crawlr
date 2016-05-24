describe Domain do
  it 'does not duplicate domain' do
    domain  = described_class.create url: 'http://mysample.com'
    new_one = described_class.create url: 'http://mysample.com'
    expect(new_one.errors).to_not be_empty
  end

  it 'creates a default root page' do
    domain = described_class.create url: 'http://mysample.com'
    expect(domain.pages.first.url).to eq('/')
  end

  describe '#reset!' do
    let(:domain) { described_class.create url: 'http://mysample.com' }

    before do
      mass_insert = MassInsert.new(domain)
      mass_insert.insert_pages  [{ url: '/another' }]
      mass_insert.insert_assets '/another', [{ url: '/asset.css' }]
    end

    it 'deletes all pages and assets within domain but keeps the root page' do
      domain.reload
      expect(domain.assets.count).to eq(1)
      expect(domain.pages.count).to eq(2)

      domain.reset!

      expect(domain.assets.count).to eq(0)
      expect(domain.pages.count).to eq(1)
      expect(domain.pages.first.url).to eq('/')
    end
  end
end
