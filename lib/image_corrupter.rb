class ImageCorrupter
  VERSION = '1.0.0'

  DEFAULT_OPTIONS = {
    interval: 5000,
    occurrences: 1,
    corruption_text: "JOSHUA OWNZ j00 ALL!!!",
    random: false,
    corruption_separator: nil
  }
  attr_accessor :file_name, :out_file_name, :file_bytes, :corrupted_file_bytes
  attr_reader :options

  Struct.new("InjectionPoint", :start, :value)

  def initialize(in_file, options = {})
    @file_name = in_file
    @file_bytes = open(@file_name).each_byte.to_a
    @corrupted_file_bytes = []
    @out_file_name = @file_name.gsub(/\.jpg/, "_corrupted.jpg")
    analyze_photo
    parse_options(options)
  end

  def corrupt
    @corrupted_file_bytes.replace(@file_bytes)
    injection_points.each {|p|
      @corrupted_file_bytes.fill(p.start, p.value.length) {|i|
        p.value[i % p.start]
      }
    }
  end

  def corrupt!
    corrupt
    @file_bytes.replace(@corrupted_file_bytes)
  end

  def self.corrupt(in_file)
    corrupting = ImageCorrupter.new(in_file)
    corrupting.corrupt
    corrupting.to_file
  end

  def to_file
    open(@out_file_name, "w") {|f|
      @corrupted_file_bytes.each {|b|
        f.putc b
      }
    }
    @out_file_name
  end

  private

    def injection_points
      step = @options[:interval]
      injecting = @options[:corruption_text]
      points = []
      (1..@options[:occurrences]).each {|i|
        index = @options[:random] ? random_index : step * i + @photo[:start_byte]
        iter_inject = injecting.kind_of?(Array) ? injecting[(i % injecting.size)-1] : injecting
        actual_length = @options[:chunk_size] || iter_inject.length
        if index + actual_length >= @photo[:end_of_image]
          actual_length = @photo[:end_of_image]-index
        end
        points << Struct::InjectionPoint.new(index, iter_inject[0...actual_length])
      }
      points
    end

    def random_index
      rand(@photo[:end_of_image]-@photo[:start_byte]) + @photo[:start_byte]
    end

    def parse_options(options = {})
      @options = DEFAULT_OPTIONS.merge(options)
      @options[:interval] = 2 if @options[:interval] < 2
      if @options[:interval] > @photo[:end_of_image]
        raise Exception.new "Interval beyond file size"
      end
      unless(@options[:corruption_file].nil?)
        temp = open(@options[:corruption_file]).read
        @options[:corruption_text] = @options[:corruption_separator].nil? ? temp : temp.split(@options[:corruption_separator])
      end
    end

    def analyze_photo
      @photo = {restart_points: []}
      file_bytes.each_with_index {|b,i|
        if b == 0xFF
          case file_bytes[i+1]
            when 0xDD
              @photo[:reset_byte] = [file_bytes[i+2], file_bytes[i+3]]
            when 0xDA
              @photo[:start_byte] = i+2
            when 0xD0..0xD7
              @photo[:restart_points] << i+2
            when 0xD9
              @photo[:end_of_image] = i
          end
        end
      }
    end

end
