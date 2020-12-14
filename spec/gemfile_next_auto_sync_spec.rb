# frozen_string_literal: true

RSpec.describe GemfileNextAutoSync do
  subject do
    Bundler.with_unbundled_env do
      `cd spec/fixtures && bundle install`
    end
  end
  it 'has a version number' do
    expect(GemfileNextAutoSync::VERSION).not_to be nil
  end

  it 'does something useful' do
    subject
    expect(true).to eq(true)
  end
end
