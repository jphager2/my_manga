# frozen_string_literal: true

require_relative 'test_helper'
require 'open3'

class FeaturesTest < Minitest::Test
  # TODO: Improve testing so that setup doesn't need to be run each time,
  #       or maybe fake the database.
  def setup
    Manga.create(
      [
        {
          name: 'Assassination Classroom',
          read_count: 0,
          total_count: 161,
          uri: 'https://www.mangareader.net/assassination-classroom'
        },
        {
          name: 'Naruto',
          read_count: 699,
          total_count: 700,
          uri: 'https://www.mangareader.net/naruto'
        },
        {
          name: 'Naruto Movie',
          read_count: 10,
          total_count: 10,
          uri: 'https://www.mangareader.net/naruto-movie'
        }
      ]
    )

    Manga.all.each do |manga|
      manga.total_count.times do |t|
        Chapter.create(
          manga: manga,
          name: "#{manga.name} #{t + 1}",
          uri: "#{manga.uri}/#{t + 1}",
          read: manga.read_count > t
        )
      end
    end
  end

  def teardown
    Manga.destroy_all
    Chapter.destroy_all
  end

  def test_env
    assert_includes `my_manga env`, 'test'
  end

  def test_binary
    _, _, _, wait_thr = Open3.popen3('my_manga', 'list', '--help')

    assert_equal 0, wait_thr.value
  end

  def test_find
    _, stdout, _, wait_thr = Open3.popen3(
      'my_manga', 'find', 'assassination classroom'
    )
    output = stdout.read
    header = 'Manga found for "assassination classroom"'
    url = 'https://www.mangareader.net/assassination-classroom'

    assert_equal 0, wait_thr.value
    assert_includes output, header
    assert_includes output, url
  end

  def test_add
    _, stdout, _, wait_thr = Open3.popen3(
      'my_manga', 'add', 'https://www.mangareader.net/nisekoi'
    )
    output = stdout.each_line.to_a
    expected = <<~EXP
      "Nisekoi" added to your library!
    EXP

    expected = expected.split("\n").map { |line| line << "\n" }

    assert_equal 0, wait_thr.value
    assert_equal expected, output
  end

  def test_remove
    _, stdout, _, wait_thr = Open3.popen3(
      'my_manga', 'remove', 'Assassination Classroom'
    )
    output = stdout.each_line.to_a
    expected = <<~EXP
      "Assassination Classroom" removed from your library!
    EXP

    expected = expected.split("\n").map { |line| line << "\n" }

    assert_equal 0, wait_thr.value
    assert_equal expected, output
  end

  def test_list
    _, stdout, _, wait_thr = Open3.popen3('my_manga', 'list')
    output = stdout.each_line.to_a
    expected = <<~EXP
      Manga list
      ==========
      Name                     Chapters read/total (unread)
      Assassination Classroom  0/161 (161) https://www.mangareader.net/assassination-classroom
      Naruto                   699/700 (1) https://www.mangareader.net/naruto
      Naruto Movie             10/10 (0) https://www.mangareader.net/naruto-movie
    EXP
    expected = expected.split("\n").map { |line| line << "\n" }

    assert_equal 0, wait_thr.value
    assert_equal expected, output
  end

  def test_list_detail
    _, stdout, _, wait_thr = Open3.popen3('my_manga', 'list', 'Naruto Movie')
    output = stdout.each_line.to_a
    expected = <<~EXP
      Manga details for "Naruto Movie"
      ================================
      Name          Chapters read/total (unread)
      Naruto Movie  10/10 (0) https://www.mangareader.net/naruto-movie

      Chapters Read
      -------------
      Naruto Movie 1
      Naruto Movie 2
      Naruto Movie 3
      ...
      Naruto Movie 10
    EXP
    expected = expected.split("\n").map { |line| line << "\n" }

    assert_equal 0, wait_thr.value
    assert_equal expected, output
  end

  def test_download
    _, stdout, _, wait_thr = Open3.popen3('my_manga', 'download')
    output = stdout.read
    expected = <<~EXP
      Downloading 161 Chapters from "Assassination Classroom"
      Downloading 1 Chapters from "Naruto"
      ...
      Finished Download!
    EXP

    assert_equal 0, wait_thr.value
    assert_equal expected, output
  end

  def test_update
    _, stdout, _, wait_thr = Open3.popen3('my_manga', 'update')
    output = stdout.read
    expected = <<~EXP
      Fetching Manga
      ...
    EXP

    assert_equal 0, wait_thr.value
    assert_equal expected, output
  end

  def test_mark
    _, stdout, _, wait_thr = Open3.popen3(
      'my_manga',
      'mark',
      'read',
      'Assassination Classroom',
      '--from=162',
      '--to=165'
    )
    output = stdout.each_line.to_a
    expected = <<~EXP
      Chapters 162-165 from "Assassination Classroom" Marked as Read
    EXP

    expected = expected.split("\n").map { |line| line << "\n" }

    assert_equal 0, wait_thr.value
    assert_equal expected[0..1], output[0..1]
  end
end
