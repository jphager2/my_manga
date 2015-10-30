class Chapter < ActiveRecord::Base
  belongs_to :manga

  scope :read, Proc.new { where(read: true) }
  scope :unread, Proc.new { where(read: false) }

  def self.from_md(md_chapter)
    create(name: md_chapter.name, uri: md_chapter.uri, number: md_chapter.chapter)
  end

  def to_md
    MDHash.new(name: name, uri: uri).to_chapter
  end
end
