require "test/unit"
require "image_corrupter"

class TestImageCorrupter < Test::Unit::TestCase
  SCRIPT_DIR = File.expand_path(File.dirname(__FILE__))
  IMAGE_TEST_FILE = "#{SCRIPT_DIR}/josh_forehead.jpg"
  IMAGE_TEST_FILE_OUT = "#{SCRIPT_DIR}/josh_forehead_corrupted.jpg"

  def setup
    File.delete(IMAGE_TEST_FILE_OUT) if File.exists?(IMAGE_TEST_FILE_OUT)
    @corrupter = ImageCorrupter.new(IMAGE_TEST_FILE)
  end

  def test_image_corruptor_takes_an_options_hash
    corrupter = ImageCorrupter.new(IMAGE_TEST_FILE, {:foo => 'bar'})
  end

  def test_image_corrupter_has_a_file_name_that_matches_input
    assert_equal(IMAGE_TEST_FILE, @corrupter.file_name)
  end

  def test_out_file_name_matches
    assert_equal(IMAGE_TEST_FILE_OUT, @corrupter.out_file_name)
  end

  def test_corrupted_file_bytes_exists
    assert @corrupter.corrupted_file_bytes
    assert_equal 0, @corrupter.corrupted_file_bytes.size
  end

  def test_file_bytes_greater_than_zero
    assert @corrupter.file_bytes.size > 0
  end

  def test_will_corrupt
    @corrupter.corrupt

    assert_not_equal 0, @corrupter.corrupted_file_bytes
    assert_equal @corrupter.file_bytes.size, @corrupter.corrupted_file_bytes.size
  end

  def test_will_corrupt!
    corrupter = ImageCorrupter.new(IMAGE_TEST_FILE)
    file_bytes = corrupter.file_bytes
    corrupter.corrupt!

    assert_not_equal 0, corrupter.file_bytes.size,
    "Data not actually corrupted, size of file_bytes is 0 (default size of corrupted_file_bytes)"
    assert_equal file_bytes.size, corrupter.file_bytes.size
    assert file_bytes != corrupter.file_bytes
  end

  def test_to_file
    @corrupter.corrupt
    @corrupter.to_file

    assert File.exists?(IMAGE_TEST_FILE_OUT)
    assert_not_equal 0, File.size(IMAGE_TEST_FILE_OUT)
  end

end
