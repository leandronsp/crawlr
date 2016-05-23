describe Page do
  it 'requires a domain and url' do
    page = described_class.create
    expect(page.errors.messages).to eq({
      url: ["can't be blank"],
      domain: ["can't be blank"]
    })
  end

  it 'does not duplicate page' do
    domain = Domain.create url: 'http://somedomain.com'
    page    = described_class.create url: '/page-1', domain: domain
    new_one = described_class.create url: '/page-1', domain: domain
    expect(new_one.errors.messages).to eq({
      url: ['has already been taken']
    })
  end
end
