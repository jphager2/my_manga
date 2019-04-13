class MangaBat < Mangdown::Adapter::Base
  site :manga_bat

  ROOT = 'https://mangabat.com/'.freeze
  CDNS = [
    %r{^https://s\d.mkklcdnv\d.com/mangakakalot}
  ].freeze

  attr_reader :root

  def self.for?(uri_or_site)
    uri_or_site.to_s.start_with?(ROOT) ||
      cdn_uri?(uri_or_site) ||
      uri_or_site.to_s == 'manga_bat'
  end

  def self.cdn_uri?(uri)
    CDNS.any? { |cdn| uri.match?(cdn) }
  end

  def initialize(uri, doc, name)
    super

    @root = ROOT
  end

  def hydra_opts
    { max_concurrency: 10 }
  end

  def is_manga_list?(uri = @uri)
    uri =~ /#{root}manga_list/
  end

  # Must return true/false if uri represents a manga for adapter
  def is_manga?(uri = @uri)
    uri =~ /#{root}manga\//
  end

  # Must return true/false if uri represents a chapter for adapter
  def is_chapter?(uri = @uri)
    uri =~ /#{root}chapter-serie\/\d+\/chap_\d+/
  end

  # Must return true/false if uri represents a page for adapter
  def is_page?(uri = @uri)
    self.class.cdn_uri?(uri)
  end

  # Return Array of Hash with keys: :uri, :name, :site
  def manga_list
    doc.css('.update_item h3 a').map { |a|
      uri = URI.join(root, a[:href]).to_s

      { uri: uri, name: a.text.strip, site: site }}
  end

  # Return Hash with keys: :uri, :name, :site
  def manga
    name ||= doc.css('h1.entry-title').first.text.strip

    { uri: uri, name: name, site: site }
  end

  # Return Array of Hash with keys: :uri, :name, :site
  def chapter_list
    chapters = doc.css('.chapter-list .row a')
    chapters.reverse.map.with_index do |a, i|
      uri = URI.join(root, a[:href]).to_s
      name = a.text.strip

      { uri: uri, name: name, chapter: i + 1, site: site }
    end
  end

  # Return Hash with keys: :uri, :name, :chapter, :manga, :site
  #
  def chapter
    name ||= chapter_name
    chapter ||= name.slice(/[\d\.]+$/)
    manga = chapter_manga_name

    { uri: uri, name: name, chapter: chapter, manga: manga, site: site }
  end

  # Return Array of Hash with keys: :uri, :name, :site
  def page_list
    doc.css('.vung_doc img').map do |img|
      uri = img['src']
      name = img.text

      { uri: uri, name: name, site: site }
    end
  end

  # Return Hash with keys: :uri, :name, :site
  def page
    name = File.basename(uri.split('/').last) if name.nil?

    { uri: uri, name: name, site: site }
  end

  private

  def chapter_name
    CGI.unescapeHTML(doc.css('h1.name_chapter').text.strip)
  end

  def chapter_manga_name
    CGI.unescapeHTML(doc.css('.breadcrumb_doc span:nth-child(3)').text.strip)
  end
end


