# frozen_string_literal: true

require_relative '../db/environment'

require 'hanami/cli'
require 'mangdown/client'

require_relative 'my_manga/cli'

module MyManga
  module_function

  def [](name)
    Manga.find_by(name: name)
  end

  def find(search)
    Mangdown::Client.find(search)
  end

  def package(dir)
    Mangdown::CBZ.all(dir)
  end

  def names
    Manga.pluck(:name)
  end

  def add_to_zine(names)
    Manga.where(name: names).update(zine: true)
  end

  def remove_from_zine(names)
    Manga.where(name: names).update(zine: false)
  end

  def zine
    Manga.where(zine: true)
  end

  def add(uri)
    return if Manga.find_by_uri(uri)

    md_manga = Mangdown.manga(uri)
    Manga.from_md(md_manga)
  end

  def remove(name)
    Manga.find_by_name(name)&.destroy
  end

  def fetch_chapters(manga, numbers)
    manga.chapters.where(number: numbers)
  end

  def read!(manga, numbers)
    set_read(manga, numbers, true)
  end

  def unread!(manga, numbers)
    set_read(manga, numbers, false)
  end

  def update(manga)
    return if env == 'test'

    md_manga = manga.to_md
    chapters = md_manga.chapters
    manga.update_chapters(chapters)
  end

  def download_chapter(chapter, download_dir)
    return if env == 'test'

    md_chapter = chapter.to_md
    md_chapter.download_to(download_dir)
  end

  def download(manga, numbers)
    unless env == 'test'
      download_dir = create_manga_download_dir(manga)
      chapters = fetch_chapters(manga, numbers)

      chapters.each do |chapter|
        download_chapter(chapter, download_dir)
      end
      package(download_dir)
    end

    read!(manga, numbers)
  end

  def mangdown_client_clean_up
    Mangdown::Client.index_manga
  end

  # @private
  def set_read(manga, numbers, bool)
    chapters = fetch_chapters(manga, numbers)
    chapters.update_all(read: bool)
    manga.reload
    manga.read_count = manga.chapters_read.length
    manga.save
  end

  # @private
  def create_manga_download_dir(manga)
    base = MyManga.download_dir
    manga_dir = [base, manga.name].join('/')
    Dir.mkdir(base) unless Dir.exist?(base)
    Dir.mkdir(manga_dir) unless Dir.exist?(manga_dir)
    manga_dir
  end
end
