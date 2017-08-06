require_relative 'test_helper'
require_relative '../../mangdown/lib/mangdown/client'
require_relative '../lib/mangdown/adapters/manga_here'
require 'timeout'

Mangdown.register_adapter(:manga_here, MangaHere)

class AdaptersTest < Minitest::Test
  def setup
    @manga_uri = 'http://www.mangahere.co/manga/bokutachi_wa_benkyou_ga_dekinai/'
  end

  def build_manga
    Mangdown::MDHash.new(uri: @manga_uri).to_manga
  end
  
  def test_creates_manga
    assert_silent do
      build_manga
    end
  end

  def test_chapter
    manga = build_manga
    chapter = nil

    Timeout.timeout(10) do
      chapter = manga.chapters[-1].to_chapter
    end

    assert chapter
  end
end
