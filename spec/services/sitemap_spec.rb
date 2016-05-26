describe Sitemap do
  let(:domain) { Domain.create(url: 'http://mysample.com') }

  subject { described_class.new(domain) }

  it 'resets the domain pages/assets before crawling' do
    allow(domain).to receive(:reset!)
    described_class.new(domain)
    expect(domain).to have_received(:reset!)
  end

  describe '#generate!' do
    let(:source) { File.read('spec/fixtures/home.html') }

    before do
      allow(RestClient::Request).to receive(:execute).and_return(source)
    end

    it 'visits all domain links and saves their assets' do
      subject.generate!
      expect(RestClient::Request).to have_received(:execute).exactly(6).times
      expect(domain.reload.pages.count).to eq(6)
      expect(domain.reload.assets.count).to eq(48) # 8 assets per page
    end
  end
end
