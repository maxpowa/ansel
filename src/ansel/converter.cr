module ANSEL
  class Converter
    include ANSEL::CharacterMap

    def self.convert(bytes : Bytes, to_charset : String = "ANSEL") : Bytes
      io = MemoryIO.new
      convert(String.new(bytes), io, to_charset)
      io.to_slice
    end

    def self.convert(string : String, to_charset : String = "ANSEL") : String
      io = MemoryIO.new
      convert(string, io, to_charset)
      String.new(io.to_slice)
    end

    def self.convert(input : IO, to_charset : String = "ANSEL") : String
      io = MemoryIO.new
      convert(input_io: input, output_io: io, to_charset: to_charset)
      io
    end

    def self.convert(string : String, output_io : IO, to_charset : String = "ANSEL")
      input_io = MemoryIO.new(string)
      convert(input_io: input_io, output_io: output_io, to_charset: to_charset)
    end

    def self.convert(bytes : Bytes, output_io : IO, to_charset : String = "ANSEL")
      input_io = MemoryIO.new(String.new(bytes))
      convert(input_io: input_io, output_io: output_io, to_charset: to_charset)
    end

    def self.convert(input_io : IO, output_io : IO, to_charset : String = "ANSEL")
      if to_charset.upcase == "ANSEL"
        convert_to_ansel(input_io, output_io)
      elsif to_charset.upcase == "UTF-8"
        convert_to_utf8(input_io, output_io)
      else
        raise Exception.new "Unsupported charset, use ANSEL or UTF-8"
      end
    end

    def self.convert_to_ansel(io, output_io)
      io.each_char do |char|

        case char.ord
        when 0x00..0x7F
          char.to_s(output_io)
        else
          if UTF16_TO_ANSI_MAP.has_key?(char.ord)
            c = UTF16_TO_ANSI_MAP[char.ord]
            int32_to_uint8(c) { |byte|
              output_io.write_byte(byte)
            }
          else
            output_io.write("?".to_slice)
          end
        end

      end
    end

    def self.convert_to_utf8(io, output_io)
      io.each_byte do |byte|

        case byte
        when 0x00..0x7F
          output_io.write_byte(byte)
        when 0x88..0xC8
          if ANSI_TO_UTF16_MAP.has_key?(byte)
            c = ANSI_TO_UTF16_MAP[byte]
            int32_to_uint8(c) do |b|
              output_io.write_byte(b)
            end
          else
            output_io.write("�".to_slice)
          end
        when 0xE0..0xFB
          [2, 1, 0].each do |n| # try 3 bytes, then 2 bytes, then 1 byte
            # Seek back one to get current byte
            io.seek(-1, IO::Seek::Current)
            # Get n+1 to get current byte and amount
            bytes = arrint8_to_uint32(io.gets(n + 1).as(String).bytes)
            # Seek back to after the current byte
            io.seek(-n, IO::Seek::Current)
            if ANSI_TO_UTF16_MAP.has_key?(bytes)
              c = ANSI_TO_UTF16_MAP[bytes]
              int32_to_uint8(c) do |b|
                output_io.write_byte(b)
              end
              break
            end
          end
        else
          output_io.write("�".to_slice)
        end
      end
    end

    def self.int32_to_uint8(value : Int32)
      yield (value >> 24).to_u8
      yield ((value >> 16) & 0xFF).to_u8
      yield ((value >> 8) & 0xFF).to_u8
      yield (value & 0xFF).to_u8
    end

    def self.arrint8_to_uint32(value : Array(UInt8))
      (value[0].to_u32 << 24) | (value[1].to_u32 << 16) | (value[2].to_u32 << 8) | value[3].to_u32
    end
  end
end
