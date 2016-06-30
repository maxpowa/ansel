require "./spec_helper"
require "power_assert"
require "spec2"

Spec2.doc
Spec2.random_order

Spec2.describe ANSEL::Converter do
  describe "#arrint8_to_uint32" do
    it "converts variable length arrays of Int8/UInt8 to a UInt32" do
      expect(ANSEL::Converter.arrint8_to_uint32([0x01.to_u8, 0x00.to_u8, 0x00.to_u8, 0x00.to_u8])).to eq 0x01000000
      expect(ANSEL::Converter.arrint8_to_uint32([0x01.to_u8, 0x01.to_u8, 0x00.to_u8, 0x00.to_u8])).to eq 0x01010000
      expect(ANSEL::Converter.arrint8_to_uint32([0x01.to_u8, 0x01.to_u8, 0x01.to_u8, 0x00.to_u8])).to eq 0x01010100
      expect(ANSEL::Converter.arrint8_to_uint32([0x01.to_u8, 0x01.to_u8, 0x01.to_u8, 0x01.to_u8])).to eq 0x01010101
      expect(ANSEL::Converter.arrint8_to_uint32([0x01.to_u8, 0x01.to_u8, 0x01.to_u8, 0x01.to_u8, 0x01.to_u8])).to eq 0x01010101
      expect(ANSEL::Converter.arrint8_to_uint32([0x01.to_u8, 0x01.to_u8, 0x01.to_u8])).to eq 0x01010100
      expect(ANSEL::Converter.arrint8_to_uint32([0x01.to_u8, 0x01.to_u8])).to eq 0x01010000
      expect(ANSEL::Converter.arrint8_to_uint32([0x01.to_u8])).to eq 0x01000000
    end
  end

  describe "#convert" do
    it "does not convert ASCII characters" do
      expect(ANSEL::Converter.convert("\u0020")).to eq " "
      expect(ANSEL::Converter.convert("\u0078")).to eq "x"
    end

    it "converts invalid characters to the unicode replacement character" do
      expect(ANSEL::Converter.convert(Slice[0xBE_u8], to_charset: "UTF-8")).to eq "�".to_slice
      expect(ANSEL::Converter.convert(Slice[0xD1_u8], to_charset: "UTF-8")).to eq "�".to_slice
    end

    it "converts valid ANSEL characters to UTF-8 equivalents" do
      # ANSEL non-combining mappings
      expect(ANSEL::Converter.convert(Slice[0xA1_u8], to_charset: "UTF-8")).to eq "Ł".to_slice
      expect(ANSEL::Converter.convert(Slice[0xA2_u8], to_charset: "UTF-8")).to eq "Ø".to_slice
      expect(ANSEL::Converter.convert(Slice[0xA3_u8], to_charset: "UTF-8")).to eq "Đ".to_slice
      expect(ANSEL::Converter.convert(Slice[0xA4_u8], to_charset: "UTF-8")).to eq "Þ".to_slice
      expect(ANSEL::Converter.convert(Slice[0xA5_u8], to_charset: "UTF-8")).to eq "Æ".to_slice
      expect(ANSEL::Converter.convert(Slice[0xA6_u8], to_charset: "UTF-8")).to eq "Œ".to_slice
      expect(ANSEL::Converter.convert(Slice[0xA7_u8], to_charset: "UTF-8")).to eq "ʹ".to_slice
      expect(ANSEL::Converter.convert(Slice[0xA8_u8], to_charset: "UTF-8")).to eq "·".to_slice
      expect(ANSEL::Converter.convert(Slice[0xA9_u8], to_charset: "UTF-8")).to eq "♭".to_slice
      expect(ANSEL::Converter.convert(Slice[0xAA_u8], to_charset: "UTF-8")).to eq "®".to_slice
      expect(ANSEL::Converter.convert(Slice[0xAB_u8], to_charset: "UTF-8")).to eq "±".to_slice
      expect(ANSEL::Converter.convert(Slice[0xAB_u8], to_charset: "UTF-8")).to eq "±".to_slice
      expect(ANSEL::Converter.convert(Slice[0xAC_u8], to_charset: "UTF-8")).to eq "Ơ".to_slice
      expect(ANSEL::Converter.convert(Slice[0xAD_u8], to_charset: "UTF-8")).to eq "Ư".to_slice
      expect(ANSEL::Converter.convert(Slice[0xAE_u8], to_charset: "UTF-8")).to eq "ʼ".to_slice
      expect(ANSEL::Converter.convert(Slice[0xB0_u8], to_charset: "UTF-8")).to eq "ʻ".to_slice
      expect(ANSEL::Converter.convert(Slice[0xB1_u8], to_charset: "UTF-8")).to eq "ł".to_slice
      expect(ANSEL::Converter.convert(Slice[0xB2_u8], to_charset: "UTF-8")).to eq "ø".to_slice
      expect(ANSEL::Converter.convert(Slice[0xB3_u8], to_charset: "UTF-8")).to eq "đ".to_slice
      expect(ANSEL::Converter.convert(Slice[0xB4_u8], to_charset: "UTF-8")).to eq "þ".to_slice
      expect(ANSEL::Converter.convert(Slice[0xB5_u8], to_charset: "UTF-8")).to eq "æ".to_slice
      expect(ANSEL::Converter.convert(Slice[0xB6_u8], to_charset: "UTF-8")).to eq "œ".to_slice
      expect(ANSEL::Converter.convert(Slice[0xB7_u8], to_charset: "UTF-8")).to eq "ʺ".to_slice
      expect(ANSEL::Converter.convert(Slice[0xB8_u8], to_charset: "UTF-8")).to eq "ı".to_slice
      expect(ANSEL::Converter.convert(Slice[0xB9_u8], to_charset: "UTF-8")).to eq "£".to_slice
      expect(ANSEL::Converter.convert(Slice[0xBA_u8], to_charset: "UTF-8")).to eq "ð".to_slice
      expect(ANSEL::Converter.convert(Slice[0xBC_u8], to_charset: "UTF-8")).to eq "ơ".to_slice
      expect(ANSEL::Converter.convert(Slice[0xBD_u8], to_charset: "UTF-8")).to eq "ư".to_slice
      expect(ANSEL::Converter.convert(Slice[0xC0_u8], to_charset: "UTF-8")).to eq "°".to_slice
      expect(ANSEL::Converter.convert(Slice[0xC1_u8], to_charset: "UTF-8")).to eq "ℓ".to_slice
      expect(ANSEL::Converter.convert(Slice[0xC2_u8], to_charset: "UTF-8")).to eq "℗".to_slice
      expect(ANSEL::Converter.convert(Slice[0xC3_u8], to_charset: "UTF-8")).to eq "©".to_slice
      expect(ANSEL::Converter.convert(Slice[0xC4_u8], to_charset: "UTF-8")).to eq "♯".to_slice
      expect(ANSEL::Converter.convert(Slice[0xC5_u8], to_charset: "UTF-8")).to eq "¿".to_slice
      expect(ANSEL::Converter.convert(Slice[0xC6_u8], to_charset: "UTF-8")).to eq "¡".to_slice
      expect(ANSEL::Converter.convert(Slice[0xC7_u8], to_charset: "UTF-8")).to eq "ß".to_slice
      expect(ANSEL::Converter.convert(Slice[0xC8_u8], to_charset: "UTF-8")).to eq "€".to_slice

      # ANSEL combining characters
      expect(ANSEL::Converter.convert(Slice[0xE0_u8, 0x41_u8], to_charset: "UTF-8")).to eq "Ả".to_slice
      expect(ANSEL::Converter.convert(Slice[0xF6_u8, 0x4C_u8], to_charset: "UTF-8")).to eq "Ḻ".to_slice
      expect(ANSEL::Converter.convert(Slice[0xF6_u8], to_charset: "UTF-8")).to eq "̲".to_slice
      expect(ANSEL::Converter.convert(Slice[0xF9_u8], to_charset: "UTF-8")).to eq "̮".to_slice
      expect(ANSEL::Converter.convert(Slice[0xF9_u8, 0x48_u8], to_charset: "UTF-8")).to eq "Ḫ".to_slice
      expect(ANSEL::Converter.convert(Slice[0xF2_u8, 0xE3_u8, 0x41_u8], to_charset: "UTF-8")).to eq "Ậ".to_slice
      expect(ANSEL::Converter.convert(Slice[0xF2_u8, 0x79_u8], to_charset: "UTF-8")).to eq "ỵ".to_slice
      expect(ANSEL::Converter.convert(Slice[0xF2_u8], to_charset: "UTF-8")).to eq "̣".to_slice
    end

    it "converts full text correctly" do
      expect(ANSEL::Converter.convert("What is the question?", to_charset: "UTF-8")).to eq "What is the question?"
      expect(ANSEL::Converter.convert("\u{00C5}What is the question?", to_charset: "UTF-8")).to eq "¿What is the question?"
      expect(ANSEL::Converter.convert("\u{00C3} 1994", to_charset: "UTF-8")).to eq "© 1994"
      expect(ANSEL::Converter.convert("\u{00B9}4.59", to_charset: "UTF-8")).to eq "£4.59"
    end
  end
end
