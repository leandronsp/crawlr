describe Page do
  it 'requires a domain and url' do
    page = described_class.create
    expect(page.errors.messages).to eq({
      url: ["can't be blank"],
      domain: ["can't be blank"]
    })
  end
end
