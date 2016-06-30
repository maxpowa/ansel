module ANSEL
  class Converter
    include ANSEL::CharacterMap

    def self.convert(bytes : Bytes, to_charset : String = "ANSEL") : Bytes
      io = MemoryIO.new
      convert(String.new(bytes), io, to_charset)
      p [bytes, io.to_slice]
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
            int32_to_uint8(c).each do |byte|
              output_io.write_byte(byte)
            end
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
            c.unsafe_chr.to_s(output_io)
          else
            '�'.to_s(output_io)
          end
        when 0xE0..0xFB
          c = decode_multibyte(io)
          c.unsafe_chr.to_s(output_io)
        else
          '�'.to_s(output_io)
        end
      end
    end

    def self.decode_multibyte(io)
      # Save pos as we're gonna be jumping around a bit
      pos = io.pos
      (0..2).reverse_each do |n| # try 3 bytes, then 2 bytes, then 1 byte
        # Seek back one to get current byte
        io.seek(-1, IO::Seek::Current)
        # Get n+1 to get current byte and amount
        bytes = 0x0_u32
        (0..(n)).each do |c|
          b = io.read_byte
          case b
          when UInt8
            b = b.to_u32 << ((1 - c) * 8)
            bytes |= b
            #p "c#{c} n#{n} b#{b} bytes#{bytes}"
          end
        end
        # Seek back to after the current byte
        if ANSI_TO_UTF16_MAP.has_key?(bytes)
          return ANSI_TO_UTF16_MAP[bytes]
        end
        # Reset pos to starting pos
        io.pos = pos
      end
      return 0xFFFD
    end

    def self.int32_to_uint8(value : Int32)
      bytes = [(value >> 24),((value >> 16) & 0xFF),((value >> 8) & 0xFF),(value & 0xFF)]
      sig = false
      output = [] of UInt8
      bytes.each do |byte|
        sig = sig || byte > 0x0
        output << byte.to_u8 if sig
      end
      output
    end

    # Variable length array of uint8 to uint32, ignoring values after the 4th in the array
    def self.arrint8_to_uint32(value : Array(UInt8))
      o = 0x0.to_u32
      idx = 0
      value.each do |val|
        o |= val.to_u32 << ((3 - idx) * 8)
        idx += 1
      end
      o
    end
  end
end
