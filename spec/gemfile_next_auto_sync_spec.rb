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

  it 'Removes shared gem from both gemfiles' do
    original_shared = File.read('spec/fixtures/Gemfile.shared')
    original_lock = File.read('spec/fixtures/Gemfile.lock')
    original_next_lock = File.read('spec/fixtures/Gemfile.next.lock')
    File.write('spec/fixtures/Gemfile.shared', original.gsub("gem 'catalogue', '0.0.1'", ''), mode: 'w')
    subject
    expect(File.read('spec/fixtures/Gemfile.lock')).not_to include 'catalogue (0.0.1)'
    expect(File.read('spec/fixtures/Gemfile.next.lock')).not_to include 'catalogue (0.0.1)'
  ensure
    File.write('spec/fixtures/Gemfile.shared', original_shared, mode: 'w')
    File.write('spec/fixtures/Gemfile.lock', original_lock, mode: 'w')
    File.write('spec/fixtures/Gemfile.next.lock', original_next_lock, mode: 'w')
  end
end
