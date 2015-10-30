require_relative 'test_helper'
require 'open3'

class FeaturesTest < Minitest::Test

  def test_env
    assert_includes `my_manga env`, "test"
  end

  def test_binary
    stdin, stdout, stderr, wait_thr = Open3.popen3("my_manga")

    assert_equal 0, wait_thr.value 
  end

  def test_find
    stdin, stdout, stderr, wait_thr = Open3.popen3("my_manga", "find", '"assassination classroom"')
    output = stdout.each_line.to_a
    expected = <<-exp
Manga found for "assassination classroom"
=========================================
Name                     Url
Assassination Classroom  http://www.mangareader.net/assassination-classroom
    exp
    expected = expected.split("\n").map { |line| line << "\n" }

    assert_equal 0, wait_thr.value
    assert_equal expected[0..2], output[0..2]
  end

  def test_add
    stdin, stdout, stderr, wait_thr = Open3.popen3("my_manga", "add", 'http://www.mangareader.net/assassination-classroom')
    output = stdout.each_line.to_a
    expected = <<-exp
"Assassination Classroom" added to your library!
    exp

    expected = expected.split("\n").map { |line| line << "\n" }

    assert_equal 0, wait_thr.value
    assert_equal expected, output
  end

  def test_remove
    stdin, stdout, stderr, wait_thr = Open3.popen3("my_manga", "remove", '"Assassination Classroom"')
    output = stdout.each_line.to_a
    expected = <<-exp
"Assassination Classroom" removed from your library!
    exp

    expected = expected.split("\n").map { |line| line << "\n" }

    assert_equal 0, wait_thr.value
    assert_equal expected, output
  end

  def test_list
    stdin, stdout, stderr, wait_thr = Open3.popen3("my_manga", "list")
    output = stdout.each_line.to_a
    expected = <<-exp
Manga list
==========
Name                     Chapters (read/total)
Assassination Classroom  0/161
Naruto                   669/700
Naruto Movie             10/10
    exp
    expected = expected.split("\n").map { |line| line << "\n" }

    assert_equal 0, wait_thr.value
    assert_equal expected[0..2], output[0..2]
  end


  def test_list_detail
    stdin, stdout, stderr, wait_thr = Open3.popen3("my_manga", "list", '"Naruto Movie"')
    output = stdout.each_line.to_a
    expected = <<-exp
Manga details for "Naruto Movie"
================================
Name          Chapters (read/total)
Naruto Movie  10/10

Chapters Read
-------------
Naruto Movie 1
Naruto Movie 2
Naruto Movie 3
...
Naruto Movie 10
    exp
    expected = expected.split("\n").map { |line| line << "\n" }

    assert_equal 0, wait_thr.value
    assert_equal expected[0..2], output[0..2]
    assert_includes output[3], "Naruto Movie"
    assert_equal expected[4..6], output[4..6]
  end

  def test_download
    stdin, stdout, stderr, wait_thr = Open3.popen3("my_manga", "download")
    output = stdout.each_line.to_a
    expected = <<-exp
Downloading 161 Chapters from "Assassination Classroom"
Downloading 1 Chapters from "Naruto"
...
Finished Download!
    exp

    expected = expected.split("\n").map { |line| line << "\n" }

    assert_equal 0, wait_thr.value
    assert_equal expected[-1], output[-1]
  end

  def test_update
    stdin, stdout, stderr, wait_thr = Open3.popen3("my_manga", "update")
    output = stdout.each_line.to_a
    expected = <<-exp
Fetching Manga
...
Updated "Assassination Classroom": 5 new Chapters.
    exp

    expected = expected.split("\n").map { |line| line << "\n" }

    assert_equal 0, wait_thr.value
    assert_equal expected[0..1], output[0..1]
  end

  def test_mark
    stdin, stdout, stderr, wait_thr = Open3.popen3("my_manga", "mark", "read", '"Assassination Classroom"', "--from=162", "--to=165")
    output = stdout.each_line.to_a
    expected = <<-exp
Chapters 162-165 from "Assassination Classroom" Marked as Read
    exp

    expected = expected.split("\n").map { |line| line << "\n" }

    assert_equal 0, wait_thr.value
    assert_equal expected[0..1], output[0..1]
  end

end

