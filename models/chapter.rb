class Chapter < ActiveRecord::Base
  belongs_to :manga

  scope :read, Proc.new { where(read: true) }
  scope :unread, Proc.new { where(read: false) }

  def self.from_md(md_chapter)
    uri = md_chapter.uri
    name = md_chapter.name
    chapter = name.slice(/\d+\z/).to_i 

    find_or_create_by(name: name, uri: uri, number: chapter)
  end

  def to_md
    Mangdown::MDHash.new(name: name, uri: uri).to_chapter
  end

  def self.numbers
    pluck(:number)
  end
end
