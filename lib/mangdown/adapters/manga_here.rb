class MangaHere < Mangdown::Adapter::Base
  site :manga_here

  ROOT = 'http://www.mangahere.co/'.freeze
  CDNS = [
    'http://l.mhcdn.net/store/manga/',
    'https://mhcdn.secure.footprint.net/store/manga/'
  ].freeze

  attr_reader :root

  def self.for?(uri_or_site)
    uri_or_site.to_s.start_with?(ROOT) ||
      cdn_uri?(uri_or_site) ||
      uri_or_site.to_s == 'manga_here'
  end

  def self.cdn_uri?(uri)
    CDNS.any? { |cdn| uri.to_s.start_with?(cdn) }
  end

  def initialize(uri, doc, name)
    super

    @root = ROOT
  end

  def hydra_opts
    { max_concurrency: 1 }
  end

  def is_manga_list?(uri = @uri)
    uri =~ /#{root}mangalist/
  end

  # Must return true/false if uri represents a manga for adapter
  def is_manga?(uri = @uri)
    uri =~ /#{root}manga\//
  end

  # Must return true/false if uri represents a chapter for adapter
  def is_chapter?(uri = @uri)
    uri =~ /#{root}.+\/c\d{3}\/?/
  end

  # Must return true/false if uri represents a page for adapter
  def is_page?(uri = @uri)
    self.class.cdn_uri?(uri)
  end

  # Return Array of Hash with keys: :uri, :name, :site
  def manga_list
    doc.css('.list_manga a.manga_info').map { |a|
      uri = URI.join(root, a[:href]).to_s

      { uri: uri, name: a.text.strip, site: site }}
  end

  # Return Hash with keys: :uri, :name, :site
  def manga
    name ||= doc.css('h1.title').first.text.strip

    { uri: uri, name: name, site: site }
  end

  # Return Array of Hash with keys: :uri, :name, :site
  def chapter_list
    chapters = doc.css('.manga_detail .detail_list ul').first.css('li a')
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
    manga = name.sub(/ #{chapter}\Z/, '').strip

    { uri: uri, name: name, chapter: chapter, manga: manga, site: site }
  end

  # Return Array of Hash with keys: :uri, :name, :site
  def page_list
    doc.css('.wid60').first.css('option').map do |option|
      uri = URI.join(root, option[:value]).to_s
      name = option.text

      { uri: uri, name: name, site: site }
    end
  end

  # Return Hash with keys: :uri, :name, :site
  def page
    if name.nil?
      option = doc.css('.wid60 option[selected]').first
      name = "#{chapter_name} - #{option.text.strip.rjust(3, '0')}"
    end

    image = doc.css('.read_img img')[1]
    uri = image[:src]

    { uri: uri, name: name, site: site }
  end

  private

  def chapter_name
    CGI.unescapeHTML(doc.css('.title h1').text.strip)
  end
end

