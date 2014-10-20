require 'spec_helper'

describe WaybackArchiver::CrawlUrl do
  let(:crawl_url) { WaybackArchiver::CrawlUrl.new('example.com') }

  describe '#url_from_relative' do 
    it 'returns correct path from base relative url' do
      url  = crawl_url.send(:url_from_relative, '/', '')
      url1 = crawl_url.send(:url_from_relative, '/path/to/resource', '')
      url3 = crawl_url.send(:url_from_relative, '', '')
      url4 = crawl_url.send(:url_from_relative, 'path/to/resource', '')
      url5 = crawl_url.absolute_url_from('person', '')
      expect(url).to  eq 'example.com/'
      expect(url1).to eq 'example.com/path/to/resource'
      expect(url3).to eq 'example.com/'
      expect(url4).to eq 'example.com/path/to/resource'
      expect(url5).to eq 'example.com/person'
    end

    it 'returns correct path from current page relative url' do
      url  = crawl_url.send(:url_from_relative, '../path/to/resource', 'http://example.com/some/path/')
      url1 = crawl_url.send(:url_from_relative, '../../path/to/resource', 'http://example.com/some/decent')
      url2 = crawl_url.send(:url_from_relative, '../../path/to/resource', 'http://example.com/some/decent/')
      expect(url).to  eq 'http://example.com/some/path/to/resource'
      expect(url1).to eq 'http://example.com/path/to/resource'
      expect(url2).to eq 'http://example.com/path/to/resource'
    end
  end

  describe '#eligible_url?' do
    it 'rejects non valid urls' do
      non_eligible = %w(javascript: callto: mailto: tel: skype: facetime: wtai: # /email-protection# # .zip .rar .pdf .exe .dmg .pkg .dpkg .bat)
      non_eligible.each do |url|
        expect(crawl_url.send(:eligible_url?, url)).to eq false
      end
    end

    it 'accepts valid urls' do
      eligible = %w(www.example.com example.com http://example.com https://example.com /path path ?q=query)
      eligible.each do |url|
        expect(crawl_url.send(:eligible_url?, url)).to eq true
      end
    end
  end
end