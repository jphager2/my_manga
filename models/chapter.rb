class Chapter < ActiveRecord::Base
  belongs_to :manga

  scope :read, Proc.new { where(read: true) }
  scope :unread, Proc.new { where(read: false) }

  def self.from_md(md_hash)
    uri = md_hash.uri
    name = md_hash.name
    site = md_hash.site
    number = md_hash.chapter

    unless number
      adapter = Mangdown.adapter!(uri, site, nil, name)
      number = adapter.chapter[:chapter]
    end

    find_or_create_by(name: name, uri: uri, number: number)
  end

  def to_md
    ::Mangdown::MDHash.new(name: name, uri: uri).to_chapter
  end

  def self.numbers
    pluck(:number)
  end
end
