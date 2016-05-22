describe 'crawling pages' do
  let(:persist_service) { PersistPages.new }

  let(:parser) do
    source = File.read('spec/fixtures/home.html')
    Parser.new(source, 'http://mysample.com')
  end

  it 'craws all pages and saving them into database' do
    parser.parse!
    persist_service.bulk_insert parser.pages

    expect(Page.count).to eq(5)
  end

  it 'does not save an existent page' do
    Page.create url: '/my-url'
    persist_service.bulk_insert [{ url: '/my-url' }]
    expect(Page.count).to eq(1)
  end
end
