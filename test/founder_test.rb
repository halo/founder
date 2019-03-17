require 'minitest/autorun'
require 'founder'

describe Founder do
  describe '.version' do
    it 'is the current Founder version' do
      value(Founder.version).must_equal '0.0.2'
    end
  end

  describe '.install' do
    it 'installs bundler and all gems' do
      Dir.mktmpdir do |workdir|
        Founder.configure do |config|
          config.gemfile_path = "#{workdir}/Gemfile"
        end
        gemfile_content = <<~GEMFILE
          source 'https://rubygems.org'
          gem 'rack', '2.0.6'
        GEMFILE
        gemfile_lock_content = <<~GEMFILE_LOCK
          GEM
            remote: https://rubygems.org/
            specs:
              rack (2.0.6)

          PLATFORMS
            ruby

          DEPENDENCIES
            rack (= 2.0.6)

          BUNDLED WITH
             2.0.1
        GEMFILE_LOCK
        Pathname.new(workdir).join('Gemfile').write gemfile_content
        Pathname.new(workdir).join('Gemfile.lock').write gemfile_lock_content

        Founder.install

        value(Founder.config.bundler_lib_path.to_s).must_equal "#{workdir}/ruby/2.3.0/gems/bundler-2.0.1/lib"
        value(Founder.config.bundler_lib_path.exist?).must_equal true
        rack_path = Founder.config.gem_path(name: 'rack', version: '2.0.6')
        value(rack_path.to_s).must_equal "#{workdir}/ruby/2.3.0/gems/rack-2.0.6"
        value(rack_path.exist?).must_equal true
        require 'rack'
        Rack.wont_be_nil
      end
    end
  end
end
