describe Sitemap do
  let(:domain) { double('domain', id: 42, url: 'http://mysample.com') }

  subject { described_class.new(domain) }

  it 'resets the domain pages/assets before crawling' do
    allow(domain).to receive(:reset!)
    described_class.new(domain)
    expect(domain).to have_received(:reset!)
  end

  describe '#generate!' do
    it 'visits all domain links and saves their assets' do

    end
  end
end
