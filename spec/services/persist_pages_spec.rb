describe PersistPages do

  describe '#bulk_insert' do
    let(:pages) do
      [
        { name: 'Page 1', url: '/page-1' },
        { name: 'Page 2', url: '/page-2' },
        { name: 'Page 3', url: '/page-3' },
        { name: 'Page 5', url: '/page-5/' },
        { name: 'Page 6', url: '/page-6/new/' }
      ]
    end

    before do
      allow(Page).to receive(:create)
      allow(Page).to receive(:exists?).and_return(false)
    end

    it 'inserts all the pages' do
      subject.bulk_insert pages
      expect(Page).to have_received(:create).exactly(5).times
    end

    context 'existent page' do
      it 'does not insert the existent ones' do
        allow(Page).to receive(:exists?).with(url: '/page-2').and_return(true)

        subject.bulk_insert pages
        expect(Page).to have_received(:create).exactly(4).times
      end
    end
  end
end
