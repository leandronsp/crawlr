require 'rails_helper'

describe SitemapsController, type: :controller do
  render_views

  describe '#generate' do
    it 'parses the domain URL and returns all pages and respective assets' do
      domain = 'http://mysample.com'
      source = File.read('spec/fixtures/home.html')
      allow(RestClient::Request).to receive(:execute).and_return(source)

      post :generate, { domain: domain }

      expect(JSON.parse(response.body)['pages']).to_not be_empty
    end
  end
end
