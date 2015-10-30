require 'mangdown'

module MyManga
  def self.[](name)
    Manga.find_by(name: name)
  end

  def self.names
    Manga.pluck(:name)
  end

  def self.add(uri)
    if Manga.find_by_uri(uri).nil?
      md_manga = Mangdown::Manga.new(uri)
      Manga.from_md(md_manga)
    end
  end

  def self.remove(name)
    manga = Manga.find_by_name(name)
    if manga
      manga.destroy
    end
  end

  def self.update(name)
    md_manga = manga.to_md
    chapters = md_chapter.chapters
    manga.update_chapters(chapters)
  end

  def self.download(chapter)
    #md_chapter = chapter.to_md
    #md_chapter.download
    chapter.read = true
    chapter.save
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
end


