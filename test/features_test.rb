require_relative 'test_helper'
require 'open3'

class FeaturesTest < Minitest::Test

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

  def test_download
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
    stdin, stdout, stderr, wait_thr = Open3.popen3("my_manga", "mark", "read", "--from=162", "--to=165", '"Assassination Classroom"')
    output = stdout.each_line.to_a
    expected = <<-exp
Chapters 162-165 from "Assassination Classroom" Marked as Read
    exp

    expected = expected.split("\n").map { |line| line << "\n" }

    assert_equal 0, wait_thr.value
    assert_equal expected[0..1], output[0..1]
  end

end

