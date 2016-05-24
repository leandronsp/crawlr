require 'rails_helper'

describe SitemapsController, type: :controller do
  render_views

  describe '#generate' do
    let(:source) { File.read('spec/fixtures/home.html') }

    before do
      allow(RestClient::Request).to receive(:execute).and_return(source)
    end

    it 'parses the domain URL and returns all pages and respective assets' do
      domain = 'http://mysample.com'
      post :generate, { domain: domain }

      expect(JSON.parse(response.body)['pages']).to_not be_empty
    end

    it 'removes the slash from domain url' do
      domain = 'http://mysample.com/'
      post :generate, { domain: domain }
      expect(Domain.last.url).to eq('http://mysample.com')
    end
  end
end
