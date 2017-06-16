# coding: utf-8
# © 2016-2017 Resurface Labs LLC

require 'resurfaceio/all'

describe UsageLoggers do

  it 'uses module namespace' do
    expect(UsageLoggers.class.equal?(Resurfaceio::UsageLoggers.class)).to be true
  end

  it 'provides default url' do
    url = UsageLoggers.url_by_default
    expect(url).to be nil
  end

end
