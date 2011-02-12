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
    file_bytes = []
    file_bytes.replace(corrupter.file_bytes)
    corrupter.corrupt!

    assert_not_equal 0, corrupter.file_bytes.size,
    "Data not actually corrupted, size of file_bytes is 0 (default size of corrupted_file_bytes)"
    assert_equal file_bytes.size, corrupter.file_bytes.size
    assert file_bytes != corrupter.file_bytes
  end

  def test_class_corrupt_convenience_method_creates_a_corrupted_file
    ImageCorrupter.corrupt(IMAGE_TEST_FILE)

    assert File.exists?(IMAGE_TEST_FILE_OUT)
    assert_not_equal 0, File.size(IMAGE_TEST_FILE_OUT)
  end

  def test_static_default_options_corruption_creates_the_same_corrupted_file_twice
    idempotent = ImageCorrupter.new(IMAGE_TEST_FILE)
    @corrupter.corrupt
    idempotent.corrupt

    assert_equal @corrupter.corrupted_file_bytes, idempotent.corrupted_file_bytes
  end

  def test_different_options_creates_two_different_corrupted_files
    optionified = ImageCorrupter.new(IMAGE_TEST_FILE, :interval => 23_000, :occurrences => 3)
    optionified.corrupt
    @corrupter.corrupt

    assert @corrupter.corrupted_file_bytes != optionified.corrupted_file_bytes, "Base corrupter and optionified had same result"
  end

  def test_corrupter_options_allows_array_of_custom_text
    optionified = ImageCorrupter.new(IMAGE_TEST_FILE, :custom_text => ["JOSHUA CLINGENPEEL", "HE IS THE OWNER OF YOU"])
    optionified.corrupt

    assert_equal optionified.file_bytes.size, optionified.corrupted_file_bytes.size
  end

  def test_corrupter_options_custom_text_array_has_same_effect_as_string
    # assumes default occurrences of 1
    options = {
      custom_text: ["JOSHUA OWNZ j00 ALL!!!", "JOSHUA CLINGENPEEL"]
    }
    optionified = ImageCorrupter.new(IMAGE_TEST_FILE, options)
    optionified.corrupt
    @corrupter.corrupt

    assert @corrupter.corrupted_file_bytes == optionified.corrupted_file_bytes

    options[:occurrences] = 2
    optionified = ImageCorrupter.new(IMAGE_TEST_FILE, options)
    optionified.corrupt

    assert @corrupter.corrupted_file_bytes != optionified.corrupted_file_bytes
  end

  def test_corrupter_chunk_size_restricts_injection
    options = {
      chunk_size: 5
    }

    optionified = ImageCorrupter.new(IMAGE_TEST_FILE, options)
    optionified.corrupt
    @corrupter.corrupt

    assert @corrupter.corrupted_file_bytes != optionified.corrupted_file_bytes
  end

  def test_random_corruption
    randomized = ImageCorrupter.new(IMAGE_TEST_FILE, :random => true)
    randomized.corrupt
    @corrupter.corrupt

    assert @corrupter.corrupted_file_bytes != randomized.corrupted_file_bytes
  end

  def test_to_file
    @corrupter.corrupt
    @corrupter.to_file

    assert File.exists?(IMAGE_TEST_FILE_OUT)
    assert_not_equal 0, File.size(IMAGE_TEST_FILE_OUT)
  end

end
