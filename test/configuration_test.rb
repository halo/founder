require 'minitest/autorun'
require 'founder'

describe Founder::Configuration do
  it 'has default settings' do
    configuration = Founder::Configuration.new

    value(configuration.gemfile_path).must_equal Pathname.getwd.join('vendor', 'Gemfile')
    value(configuration.download_path).must_equal Pathname.getwd.join('vendor')
    value(configuration.bundler_version).must_equal '2.0.1'
    value(configuration.gems_path).must_equal Pathname.getwd.join('vendor', 'ruby', '2.3.0')
  end
end
