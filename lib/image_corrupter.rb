class ImageCorrupter
  VERSION = '1.0.0'

  DEFAULT_OPTIONS = {
    interval: 5000,
    occurrences: 1,
    custom_text: "JOSHUA OWNZ j00 ALL!!!",
    random: false
  }
  attr_accessor :file_name, :out_file_name, :file_bytes, :corrupted_file_bytes

  Struct.new("InjectionPoint", :start, :value)

  def initialize(in_file, options = {})
    @file_name = in_file
    @file_bytes = open(@file_name).each_byte.to_a
    @corrupted_file_bytes = []
    @out_file_name = @file_name.gsub(/\.jpg/, "_corrupted.jpg")
    parse_options(options)
    analyze_photo
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
      injecting = @options[:custom_text]
      points = []
      (1..@options[:occurrences]).each {|i|
        index = @options[:random] ? random_index : step * i
        iter_inject = @options[:custom_text].kind_of?(Array) ? injecting[(i % injecting.size)-1] : injecting
        points << Struct::InjectionPoint.new(index, iter_inject[0...(@options[:chunk_size] || iter_inject.length)])
      }
      points
    end

    def random_index
      rand(@photo[:end_of_img]-@photo[:start_byte]) + @photo[:start_byte]
    end

    def parse_options(options = {})
      @options = DEFAULT_OPTIONS.merge(options)
      unless(@options[:corruption_text_file].nil?)

      end
    end

    def analyze_photo
      @photo = {}
      @photo[:restart_points] = []
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
              @photo[:end_of_img] = i+2
          end
        end
      }
    end

end
