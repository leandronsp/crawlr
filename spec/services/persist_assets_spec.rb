describe PersistAssets do

  let(:domain) { double('domain', id: 42, url: 'http://mysample.com') }

  subject { PersistAssets.new(domain) }

  describe '#insert_assets_for' do
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

    it 'ensures to insert a fresh collection to the page' do
      allow(Page).to receive(:where).with(url: '/page-1').and_return([page])
      allow(Asset).to receive(:destroy_all).with(page: page)
      allow(Asset).to receive(:create)

      subject.insert_assets_for('/page-1', assets)

      expect(Asset).to have_received(:destroy_all).with(page: page)

      assets.each do |asset|
        expect(Asset).to have_received(:create).with({
          url: asset[:url],
          page: page
        })
      end
    end

    context 'page does not exist' do
      it 'creates the page and insert the assets' do
        allow(Page).to receive(:where).and_return([])
        allow(Page).to receive(:create).with(url: '/page-1', domain: domain)
                                       .and_return(page)
        allow(Asset).to receive(:create)
        allow(Asset).to receive(:destroy_all)

        subject.insert_assets_for('/page-1', assets)

        expect(Page).to have_received(:create).with(url: '/page-1', domain: domain)
        expect(Asset).to_not have_received(:destroy_all)

        assets.each do |asset|
          expect(Asset).to have_received(:create).with({
            url: asset[:url],
            page: page
          })
        end
      end
    end

  end
end
