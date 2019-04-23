class Chapter < ActiveRecord::Base
  belongs_to :manga

  scope :read, Proc.new { where(read: true) }
  scope :unread, Proc.new { where(read: false) }

  def self.from_md(md_chapter)
    md_chapter.chapter.load unless md_chapter.number

    find_or_create_by(
      name: md_chapter.name,
      uri: md_chapter.uri,
      number: md_chapter.number
    )
  end

  def to_md
    ::Mangdown.chapter(uri)
  end

  def self.numbers
    pluck(:number)
  end
end
