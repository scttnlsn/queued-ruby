$:.unshift File.expand_path('../../lib', __FILE__)

require 'queued'
require 'webmock/rspec'

WebMock.disable_net_connect!