class Manga < ActiveRecord::Base
  self.table_name = "manga"

  has_many :chapters, dependent: :destroy

  delegate :read, :unread, to: :chapters, prefix: true, allow_nil: false
  delegate :numbers, to: :chapters_unread, prefix: true, allow_nil: false
  delegate :numbers, to: :chapters, prefix: true, allow_nil: false

  def self.from_md(md_manga)
    manga = find_or_create_by(name: md_manga.name, uri: md_manga.uri)
    manga.update_chapters(md_manga.chapters)
    manga
  end

  def update_chapters(fetched_chapters)
    fetched_chapters.each do |md|
      chapter = Chapter.from_md(md)
      chapter.manga = self
      chapter.save
    end
    self.total_count = chapters.count
    save!
  end

  def to_md
    ::Mangdown.manga(uri)
  end

  def chapters
    super.order(:number)
  end
end
