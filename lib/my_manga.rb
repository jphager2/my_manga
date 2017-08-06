require 'mangdown/client'
require_relative 'mangdown/adapters/manga_here'

Mangdown.register_adapter(:manga_here, MangaHere)
M::MANGA_PAGES << 'http://www.mangahere.co/mangalist/'

module MyManga
  def self.[](name)
    Manga.find_by(name: name)
  end

  def self.find(search)
    M.find(Regexp.new(search, 'i'))
  end

  def self.package(dir)
    Mangdown::CBZ.all(dir)
  end

  def self.names
    Manga.pluck(:name)
  end

  def self.add(uri)
    if Manga.find_by_uri(uri).nil?
      md_manga = Mangdown::MDHash.new(uri: uri).to_manga
      Manga.from_md(md_manga)
    end
  end

  def self.remove(name)
    manga = Manga.find_by_name(name)
    if manga
      manga.destroy
    end
  end

  def self.fetch_chapters(manga, numbers)
    manga.chapters.where(number: numbers)
  end

  # This should be private
  def self.set_read(manga, numbers, bool)
    chapters = fetch_chapters(manga, numbers)
    chapters.update_all(read: bool)
    manga.reload
    manga.read_count = manga.chapters_read.length
    manga.save
  end

  def self.read!(manga, numbers)
    set_read(manga, numbers, true)
  end

  def self.unread!(manga, numbers)
    set_read(manga, numbers, false)
  end

  def self.update(manga)
    md_manga = manga.to_md
    chapters = md_manga.chapters
    manga.update_chapters(chapters)
  end

  # Should be private
  def self.create_manga_download_dir(manga)
    base = MyManga.download_dir
    manga_dir = [base, manga.name].join("/")
    Dir.mkdir(base) unless Dir.exist?(base)
    Dir.mkdir(manga_dir) unless Dir.exist?(manga_dir)
    manga_dir
  end

  def self.download_chapter(chapter, download_dir)
    md_chapter = chapter.to_md
    md_chapter.download_to(download_dir)
  end

  def self.download(manga, numbers)
    download_dir = create_manga_download_dir(manga)
    chapters = fetch_chapters(manga, numbers)

    chapters.each do |chapter|
      download_chapter(chapter, download_dir)
    end
    package(download_dir)
    read!(manga, numbers)
  end

  def self.read_chapter_groups(name)
    self[name].chapters.each_with_object([]) { |chapter, groups| 
      if groups[-1].nil?
        groups << [chapter]
      else
        if chapter.number - groups[-1][-1].number == 1
          groups[-1] << chapter
        else
          groups << [chapter]
        end
      end
    }
  end

  def self.mangdown_client_clean_up
    M.clean_up
  end
end


