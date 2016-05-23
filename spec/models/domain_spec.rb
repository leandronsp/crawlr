describe Domain do
  it 'does not duplicate domain' do
    domain  = described_class.create url: 'http://mysample.com'
    new_one = described_class.create url: 'http://mysample.com'
    expect(new_one.errors).to_not be_empty
  end

end
