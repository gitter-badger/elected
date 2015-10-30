require 'spec_helper'

describe Elected do

  let(:custom_key) { 'some_key' }
  let(:custom_timeout) { 5_000 }

  it 'has a version number' do
    expect(Elected::VERSION).not_to be nil
  end

  it 'has default redis urls' do
    expect(described_class.redis_urls).to eq ENV['REDIS_URL'].split('|')
  end

  it 'can set default redis urls' do
    Elected.redis_urls = ['a', 'b|c']
    expect(described_class.redis_urls).to eq %w{ a b c }
  end

  it 'has a redlock client' do
    expect(described_class.electorado).to be_a ::Redlock::Client
  end

  it 'has default key' do
    expect(described_class.key).to eq DEFAULT_KEY
  end

  it 'can set key' do
    described_class.key = custom_key
    expect(described_class.key).to eq custom_key
  end

  it 'has default timeout' do
    expect(described_class.timeout).to eq DEFAULT_TIMEOUT
  end

  it 'can set timeout' do
    described_class.timeout = custom_timeout
    expect(described_class.timeout).to eq custom_timeout
  end

  it 'has a default senado' do
    expect(described_class.senado).to be_a Elected::Senado
  end

end
