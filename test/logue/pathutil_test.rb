#!/usr/bin/ruby -w
# -*- ruby -*-

require 'test/unit'
require 'logue/pathutil'

class Logue::PathUtilTestCase < Test::Unit::TestCase
  # trim_left

  def run_trim_left_test expected, length, str = "something"
    trimmed = Logue::PathUtil.trim_left str, length
    assert_equal expected, trimmed
  end

  def test_trim_left_short_positive_number
    run_trim_left_test "some", 4
  end

  def test_trim_left_long
    run_trim_left_test "something", 10
  end

  def test_trim_left_short_negative_number
    run_trim_left_test "some", -4
  end

  # trim_right

  def assert_trim_right expected, length, str
    trimmed = Logue::PathUtil.trim_right str, length
    assert_equal expected, trimmed, "length: #{length}"
  end

  def test_trim_right_path_excess
    assert_trim_right "ab/cd/ef.t", 11, "ab/cd/ef.t"
  end

  def test_trim_right_path_at_length
    assert_trim_right "ab/cd/ef.t", 10, "ab/cd/ef.t"
  end

  def test_trim_right_path_one_less
    assert_trim_right ".../ef.t", 9, "ab/cd/ef.t"
  end

  def test_trim_right_path_two_less
    assert_trim_right ".../ef.t", 8, "ab/cd/ef.t"
  end

  def test_trim_right_path_three_less
    assert_trim_right "ef.t", 7, "ab/cd/ef.t"
  end

  def test_trim_right_path_four_less
    assert_trim_right "ef.t", 6, "ab/cd/ef.t"
  end

  def test_trim_right_path_five_less
    assert_trim_right "ef.t", 5, "ab/cd/ef.t"
  end

  def test_trim_right_path_six_less
    assert_trim_right "ef.t", 4, "ab/cd/ef.t"
  end

  def test_trim_right_path_seven_less
    assert_trim_right "ef.t", 3, "ab/cd/ef.t"
  end

  def test_trim_right_path_eight_less
    assert_trim_right "ef.t", 2, "ab/cd/ef.t"
  end
end
