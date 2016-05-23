require 'capybara/rails'
require 'capybara/rspec'

describe 'after user input, the page is redirected to the sitemap', type: :feature do
  let(:domain) { 'http://mysample.com' }

  before do
    source = File.read('spec/fixtures/home.html')
    allow(RestClient).to receive(:get).and_return(source)
  end

  it 'inputs a domain and redirects to the sitemap result' do
    visit '/sitemaps/new'

    within 'form#sitemap'  do
      fill_in :domain, with: domain
    end

    click_button 'Generate sitemap'

    within "div[data-url='#{domain}'] ul" do
      expect(page).to have_content "#{domain}/home.css"
    end

    #within "div[data-url='#{domain}/page-1'] ul" do
    #  expect(page).to have_content "#{domain}/page-1.css"
    #end
  end
end
