describe MagicBell::Config do
  let(:config) { MagicBell::Config.new }

  it 'api host defaults to api.magicbell.io' do
    expect(config.api_host).to eq 'https://api.magicbell.io'
  end

  it 'has the api key provided it is set' do
    config.api_key= 'A key'

    expect(config.api_key).to eq 'A key'
  end

  it 'has the api secret provided it is set' do
    config.api_secret= 'a secret'

    expect(config.api_secret).to eq 'a secret'
  end

  it 'has the max network retries provided it is set' do
    config.max_network_retries=11

    expect(config.max_network_retries).to eq 11
  end

  it 'defaults to 2 network retries when non provided' do
    expect(config.max_network_retries).to eq 2
  end
end
