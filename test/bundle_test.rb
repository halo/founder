require 'minitest/autorun'
require 'founder'

describe Founder::Bundle do
  describe 'without Gemfile or Gemfile.lock' do
    it 'aborts' do
      Dir.mktmpdir do |workdir|
        Founder.configure do |config|
          config.gemfile_path = "#{workdir}/Gemfile"
        end

        -> { Founder::Bundle.new.call }.must_raise SystemExit

        Pathname.new(workdir).join('Gemfile').write 'Dummy Gemfile content'

        -> { Founder::Bundle.new.call }.must_raise SystemExit
      end
    end
  end
end

