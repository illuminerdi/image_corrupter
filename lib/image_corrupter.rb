class ImageCorrupter
  VERSION = '1.0.0'

  attr_accessor :file_name, :out_file_name, :file_bytes, :corrupted_file_bytes

  def initialize(in_file, options = {})
    @file_name = in_file
    @file_bytes = open(@file_name).each_byte.to_a
    @corrupted_file_bytes = []
    @out_file_name = @file_name.gsub(/\.jpg/, "_corrupted.jpg")
    parse_options(options)
    analyze_photo
  end

  def corrupt
    temp_file_bytes = @file_bytes
    step = 5000
    injecting = "JOSHUA"
    6.times {|i|
      @corrupted_file_bytes = temp_file_bytes.fill(step*i,6) {|j|
        injecting[j]
      }
    }
    @corrupted_file_bytes = temp_file_bytes.fill(5000,)
    temp_file_bytes.each_with_index {|b,i|
      if(i > @photo[:start_byte] && !corrupted)
        "JOSHUA".each_char {|c|
          @corrupted_file_bytes << c
        }
        corrupted = true
        temp_file_bytes.slice!(i,"JOSHUA".length-1)
      else
        @corrupted_file_bytes << b
      end
    }
  end

  def corrupt!
    corrupt
    @file_bytes = @corrupted_file_bytes
  end

  def to_file
    open(@out_file_name, "w") {|f|
      @corrupted_file_bytes.each {|b|
        f.putc b
      }
    }
  end

  private

  def parse_options(options = {})

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
