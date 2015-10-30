class Manga < ActiveRecord::Base
  self.table_name = "manga"

  has_many :chapters

  delegate :read, :unread, to: :chapters, prefix: true, allow_nil: false

  def self.from_md(md_manga)
    manga = create(name: md_manga.name, uri: md_manga.uri)
    manga.update_chapters(md_manga.chapters)
    manga
  end

  def update_chapters(fetched_chapters)
    # Add Chapters with new names
    self.total_count = fetched_chapters.length
    save!
  end

  def to_md
    MDHash.new(name: name, uri: uri).to_manga
  end
end
