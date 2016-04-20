# coding: utf-8
# Copyright (c) 2016 Resurface Labs LLC, All Rights Reserved

require 'resurfaceio/logger'
require_relative 'mocks'

describe HttpLoggerForRack do

  it 'uses module namespace' do
    expect(HttpLoggerForRack.class.equal?(Resurfaceio::HttpLoggerForRack.class)).to be true
  end

  it 'logs rack call (html)' do
    logger = HttpLoggerFactory.get.disable.tracing_start
    begin
      HttpLoggerForRack.new(MockHtmlApp.new).call(MOCK_ENV)
      expect(logger.tracing_history.length).to eql(2)
      expect(logger.tracing_history[0].include?("{\"category\":\"http_request\",")).to be true
      expect(logger.tracing_history[0].include?("\"url\":\"#{MOCK_URL}\"}")).to be true
      expect(logger.tracing_history[1].include?("{\"category\":\"http_response\",")).to be true
      expect(logger.tracing_history[1].include?("\"code\":200",)).to be true
      expect(logger.tracing_history[1].include?("\"body\":\"#{MOCK_HTML_ESCAPED}\"}")).to be true
    ensure
      logger.tracing_stop.enable
    end
  end

  it 'logs rack call (json)' do
    logger = HttpLoggerFactory.get.disable.tracing_start
    begin
      HttpLoggerForRack.new(MockJsonApp.new).call(MOCK_ENV)
      expect(logger.tracing_history.length).to eql(2)
      expect(logger.tracing_history[0].include?("{\"category\":\"http_request\",")).to be true
      expect(logger.tracing_history[0].include?("\"url\":\"#{MOCK_URL}\"}")).to be true
      expect(logger.tracing_history[1].include?("{\"category\":\"http_response\",")).to be true
      expect(logger.tracing_history[1].include?("\"code\":200",)).to be true
      expect(logger.tracing_history[1].include?("\"body\":\"#{MOCK_JSON_ESCAPED}\"}")).to be true
    ensure
      logger.tracing_stop.enable
    end
  end

  it 'skips logging for redirects and unmatched content types' do
    logger = HttpLoggerFactory.get.disable.tracing_start
    begin
      apps = [MockCustomApp.new, MockCustomRedirectApp.new, MockHtmlRedirectApp.new]
      apps.each do |app|
        HttpLoggerForRack.new(app).call(MOCK_ENV)
        expect(logger.tracing_history.length).to eql(0)
      end
    ensure
      logger.tracing_stop.enable
    end
  end

end
