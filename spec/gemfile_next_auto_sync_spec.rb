# frozen_string_literal: true

RSpec.describe GemfileNextAutoSync do
  subject do
    Bundler.with_original_env do
      `cd spec/fixtures && bundle install`
    end
  end
  let!(:original_gemfile) { File.read('spec/fixtures/Gemfile') }
  let!(:original_gemfile_next) { File.read('spec/fixtures/Gemfile') }
  let!(:original_shared) { File.read('spec/fixtures/Gemfile.shared') }
  let!(:original_lock) { File.read('spec/fixtures/Gemfile.lock') }
  let!(:original_next_lock) { File.read('spec/fixtures/Gemfile.next.lock') }

  after(:each) do
    File.write('spec/fixtures/Gemfile', original_gemfile, mode: 'w')
    File.write('spec/fixtures/Gemfile.next', original_gemfile_next, mode: 'w')
    File.write('spec/fixtures/Gemfile.shared', original_shared, mode: 'w')
    File.write('spec/fixtures/Gemfile.lock', original_lock, mode: 'w')
    File.write('spec/fixtures/Gemfile.next.lock', original_next_lock, mode: 'w')
  end

  it 'Both gemfiles include shared gems' do
    subject
    expect(File.read('spec/fixtures/Gemfile.lock')).to include 'catalogue (0.0.1)'
    expect(File.read('spec/fixtures/Gemfile.next.lock')).to include 'catalogue (0.0.1)'
  end

  it 'Removes shared gem from both gemfiles' do
    File.write('spec/fixtures/Gemfile.shared', original_shared.gsub("gem 'catalogue', '0.0.1'", ''), mode: 'w')
    subject
    expect(File.read('spec/fixtures/Gemfile.lock')).not_to include 'catalogue (0.0.1)'
    expect(File.read('spec/fixtures/Gemfile.next.lock')).not_to include 'catalogue (0.0.1)'
  end

  it 'Append shared gems to both gemfiles' do
    File.write('spec/fixtures/Gemfile.shared', original_shared + "\ngem 'Generator_pdf'\n", mode: 'w')
    subject
    expect(File.read('spec/fixtures/Gemfile.lock')).to include 'Generator_pdf'
    expect(File.read('spec/fixtures/Gemfile.next.lock')).to include 'Generator_pdf'
  end

  it 'Can contain different versions of gems' do
    File.write('spec/fixtures/Gemfile', original_gemfile + "\ngem 'Generator_pdf', '0.0.1'\n", mode: 'w')
    File.write('spec/fixtures/Gemfile.next', original_gemfile_next + "\ngem 'Generator_pdf', '0.0.2'\n", mode: 'w')
    subject
    expect(File.read('spec/fixtures/Gemfile.lock')).to include 'Generator_pdf (0.0.1)'
    expect(File.read('spec/fixtures/Gemfile.next.lock')).to include 'Generator_pdf (0.0.2)'
  end
end
