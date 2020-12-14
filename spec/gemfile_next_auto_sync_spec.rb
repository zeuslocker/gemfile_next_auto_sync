# frozen_string_literal: true

RSpec.describe GemfileNextAutoSync do
  subject do
    Bundler.with_original_env do
      `cd spec/fixtures && bundle install`
    end
  end
  it 'has a version number' do
    expect(GemfileNextAutoSync::VERSION).not_to be nil
  end

  it 'Both gemfiles include shared gems' do
    subject
    expect(File.read('spec/fixtures/Gemfile.lock')).to include 'catalogue (0.0.1)'
    expect(File.read('spec/fixtures/Gemfile.next.lock')).to include 'catalogue (0.0.1)'
  end
end
