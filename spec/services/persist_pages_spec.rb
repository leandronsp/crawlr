describe PersistPages do

  let(:domain) { double('domain', id: 42, url: 'http://mysample.com') }
  subject      { PersistPages.new(domain) }

  describe '#bulk_insert' do
    let(:pages) do
      [
        { url: '/' },
        { url: '/page-1' },
        { url: '/page-2' },
        { url: '/page-3' },
        { url: '/page-5/' },
        { url: '/page-6/new/' }
      ]
    end

    before do
      allow(Page).to receive(:create)
      allow(Page).to receive(:exists?).and_return(false)
    end

    it 'inserts all the pages' do
      subject.bulk_insert pages
      expect(Page).to have_received(:create).exactly(6).times
    end

    context 'existent page' do
      it 'does not insert the existent ones' do
        allow(Page).to receive(:exists?).with(url: '/page-2', domain_id: domain.id).and_return(true)

        subject.bulk_insert pages
        expect(Page).to have_received(:create).exactly(5).times
      end

    end
  end
end
