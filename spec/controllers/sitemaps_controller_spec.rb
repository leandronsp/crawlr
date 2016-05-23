require 'rails_helper'

describe SitemapsController, type: :controller do
  render_views

  describe '#new' do
    it 'renders the form to input the domain' do
      get :new
      expect(response.body).to have_content('Domain')
      expect(response.body).to have_content('Generate sitemap')
    end
  end

  describe '#generate' do
    it 'parses the domain URL and returns all pages and respective assets' do
      domain = 'http://mysample.com'
      source = File.read('spec/fixtures/home.html')
      allow(RestClient).to receive(:get).with(domain).and_return(source)

      post :generate, { domain: domain }

      expect(response.body).to have_content("#{Domain.last.url}/page-1")
    end
  end
end
