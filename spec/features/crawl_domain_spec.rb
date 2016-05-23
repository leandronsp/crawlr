#require 'capybara/rails'
#require 'capybara/rspec'
#
#describe 'after user input, the page is redirected to the sitemap', type: :feature do
#  it 'inputs a domain and redirects to the sitemap result' do
#    visit '/sitemaps/new'
#
#    within 'form#sitemap'  do
#      fill_in :domain, with: 'http://mysample.com'
#    end
#
#    click_button 'Generate sitemap'
#    expect(page).to have_content('Sitemap generated')
#  end
#end
