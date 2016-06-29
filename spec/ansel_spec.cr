require "./spec_helper"
require "power_assert"
require "spec2"

Spec2.describe ANSEL::Converter do

  describe "#convert" do

    it "does not convert ASCII characters" do
      expect(ANSEL::Converter.convert("\u0020")).to eq " "
      expect(ANSEL::Converter.convert("\u0078")).to eq "x"
    end

    it "converts invalid characters to the unicode replacement character" do
      expect(ANSEL::Converter.convert("\u00BE", to_charset: "UTF-8")).to eq "�"
      expect(ANSEL::Converter.convert("\u00D1", to_charset: "UTF-8")).to eq "�"
    end

    it "converts valid ANSEL characters to UTF-8 equivalents" do
      # ANSEL non-combining mappings
      # TODO: These need to be shifted to be 00 prefixed.
      expect(ANSEL::Converter.convert("\uA100", to_charset: "UTF-8")).to eq "Ł"
      expect(ANSEL::Converter.convert("\uA200", to_charset: "UTF-8")).to eq "Ø"
      expect(ANSEL::Converter.convert("\uA300", to_charset: "UTF-8")).to eq "Đ"
      expect(ANSEL::Converter.convert("\uA400", to_charset: "UTF-8")).to eq "Þ"
      expect(ANSEL::Converter.convert("\uA500", to_charset: "UTF-8")).to eq "Æ"
      expect(ANSEL::Converter.convert("\uA600", to_charset: "UTF-8")).to eq "Œ"
      expect(ANSEL::Converter.convert("\uA700", to_charset: "UTF-8")).to eq "ʹ"
      expect(ANSEL::Converter.convert("\uA800", to_charset: "UTF-8")).to eq "·"
      expect(ANSEL::Converter.convert("\uA900", to_charset: "UTF-8")).to eq "♭"
      expect(ANSEL::Converter.convert("\uAA00", to_charset: "UTF-8")).to eq "®"
      expect(ANSEL::Converter.convert("\uAB00", to_charset: "UTF-8")).to eq "±"
      expect(ANSEL::Converter.convert("\uAB00", to_charset: "UTF-8")).to eq "±"
      expect(ANSEL::Converter.convert("\uAC00", to_charset: "UTF-8")).to eq "Ơ"
      expect(ANSEL::Converter.convert("\uAD00", to_charset: "UTF-8")).to eq "Ư"
      expect(ANSEL::Converter.convert("\uAE00", to_charset: "UTF-8")).to eq "ʼ"
      expect(ANSEL::Converter.convert("\uB000", to_charset: "UTF-8")).to eq "ʻ"
      expect(ANSEL::Converter.convert("\uB100", to_charset: "UTF-8")).to eq "ł"
      expect(ANSEL::Converter.convert("\uB200", to_charset: "UTF-8")).to eq "ø"
      expect(ANSEL::Converter.convert("\uB300", to_charset: "UTF-8")).to eq "đ"
      expect(ANSEL::Converter.convert("\uB400", to_charset: "UTF-8")).to eq "þ"
      expect(ANSEL::Converter.convert("\uB500", to_charset: "UTF-8")).to eq "æ"
      expect(ANSEL::Converter.convert("\uB600", to_charset: "UTF-8")).to eq "œ"
      expect(ANSEL::Converter.convert("\uB700", to_charset: "UTF-8")).to eq "ʺ"
      expect(ANSEL::Converter.convert("\uB800", to_charset: "UTF-8")).to eq "ı"
      expect(ANSEL::Converter.convert("\uB900", to_charset: "UTF-8")).to eq "£"
      expect(ANSEL::Converter.convert("\uBA00", to_charset: "UTF-8")).to eq "ð"
      expect(ANSEL::Converter.convert("\uBC00", to_charset: "UTF-8")).to eq "ơ"
      expect(ANSEL::Converter.convert("\uBD00", to_charset: "UTF-8")).to eq "ư"
      expect(ANSEL::Converter.convert("\uC000", to_charset: "UTF-8")).to eq "°"
      expect(ANSEL::Converter.convert("\uC100", to_charset: "UTF-8")).to eq "ℓ"
      expect(ANSEL::Converter.convert("\uC200", to_charset: "UTF-8")).to eq "℗"
      expect(ANSEL::Converter.convert("\uC300", to_charset: "UTF-8")).to eq "©"
      expect(ANSEL::Converter.convert("\uC400", to_charset: "UTF-8")).to eq "♯"
      expect(ANSEL::Converter.convert("\uC500", to_charset: "UTF-8")).to eq "¿"
      expect(ANSEL::Converter.convert("\uC600", to_charset: "UTF-8")).to eq "¡"
      expect(ANSEL::Converter.convert("\uC700", to_charset: "UTF-8")).to eq "ß"
      expect(ANSEL::Converter.convert("\uC800", to_charset: "UTF-8")).to eq "€"

      # ANSEL combining characters
      expect(ANSEL::Converter.convert("\uE041", to_charset: "UTF-8")).to eq "Ả"
      expect(ANSEL::Converter.convert("\uF64C", to_charset: "UTF-8")).to eq "Ḻ"
      expect(ANSEL::Converter.convert("\u00F6", to_charset: "UTF-8")).to eq "̲"
      expect(ANSEL::Converter.convert("\u00F9", to_charset: "UTF-8")).to eq "̮"
      expect(ANSEL::Converter.convert("\uF948", to_charset: "UTF-8")).to eq "Ḫ"
      expect(ANSEL::Converter.convert("\uF2E3\u0041", to_charset: "UTF-8")).to eq "Ậ"
      expect(ANSEL::Converter.convert("\uF279", to_charset: "UTF-8")).to eq "ỵ"
      expect(ANSEL::Converter.convert("\u00F2", to_charset: "UTF-8")).to eq "̣"
    end

    it "converts full text correctly" do
      expect(ANSEL::Converter.convert("What is the question?", to_charset: "UTF-8")).to eq "What is the question?"
      expect(ANSEL::Converter.convert("\u{C500}What is the question?", to_charset: "UTF-8")).to eq "¿What is the question?"
      expect(ANSEL::Converter.convert("\u{C300} 1994", to_charset: "UTF-8")).to eq "© 1994"
      expect(ANSEL::Converter.convert("\u{B900}4.59", to_charset: "UTF-8")).to eq "£4.59"
    end

  end

end
