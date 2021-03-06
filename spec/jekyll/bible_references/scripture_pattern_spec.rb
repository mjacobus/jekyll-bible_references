# frozen_string_literal: true

RSpec.describe Jekyll::BibleReferences::ScripturePattern do
  subject(:pattern) { described_class.new }

  let(:matches) { matches_for(text) }
  let(:text) { scriptures.join }
  let(:scriptures) { [] }

  def matches_for(string)
    pattern.match(string)

    Regexp.last_match
  end

  describe "matching prefixes" do
    it "matches scriptures with one space between prefix and book" do
      scriptures.push "1 Corinthians 3:1-4"

      expect(matches[:prefix]).to eq("1")
    end

    it "matches scriptures with two spaces between prefix and book" do
      scriptures.push "1  Corinthians 3:1-4"

      expect(matches[:prefix]).to eq("1")
    end

    it "matches scriptures with no spaces between prefix and book" do
      scriptures.push "1Corinthians 3:1-4"

      expect(matches[:prefix]).to eq("1")
    end

    it "matches scriptures with no prefix" do
      scriptures.push "Genesis 3:1-4"

      expect(matches[:prefix]).to be_empty
    end

    it "matches no prefix lead by space" do
      scriptures.push " Genesis 3:1-4"

      expect(matches[:prefix]).to be_empty
    end
  end

  describe "matching books" do
    it "matches scriptures with one space between prefix and book" do
      scriptures.push "1 Corinthians 3:1-4"

      expect(matches[:book]).to eq("Corinthians")
    end

    it "matches scriptures with two spaces between prefix and book" do
      scriptures.push "1  Corinthians 3:1-4"

      expect(matches[:book]).to eq("Corinthians")
    end

    it "matches scriptures with no spaces between prefix and book" do
      scriptures.push "1Corinthians 3:1-4"

      expect(matches[:book]).to eq("Corinthians")
    end

    it "matches scriptures with no spaces between book and verses" do
      scriptures.push "1 Corinthians3:1-4"

      expect(matches[:book]).to eq("Corinthians")
    end

    it "matches scriptures with no prefix" do
      scriptures.push "Genesis 3:1-4"

      expect(matches[:book]).to eq("Genesis")
    end

    it "matches scriptures with accents" do
      scriptures.push "G??nesis 3:1-4"

      expect(matches[:book]).to eq("G??nesis")
    end

    it "matches book lead by space" do
      scriptures.push " Genesis 3:1-4"

      expect(matches[:book]).to eq("Genesis")
    end
  end

  describe "matching single verses" do
    it "matches scriptures with one space between book and verses" do
      scriptures.push "1 Corinthians 3:4"

      expect(matches[:verses]).to eq("3:4")
    end

    it "matches scriptures with two spaces between book and verses" do
      scriptures.push "1  Corinthians  3:14"

      expect(matches[:verses]).to eq("3:14")
    end

    it "matches scriptures with no spaces between book and verses" do
      scriptures.push "1 Corinthians3:14"

      expect(matches[:verses]).to eq("3:14")
    end
  end

  describe "matching scriptures with a single chapter" do
    xit "matches scriptures with a single chapter" do
      scriptures.push "Jude 17"

      expect(matches[:verses]).to eq("17")
    end

    xit "matches multiple verses" do
      scriptures.push "Jude 17,19,21"

      expect(matches[:verses]).to eq("17,19,21")
    end

    xit "matches multiple verses, some with spaces in between" do
      scriptures.push "Jude 17,19, 21"

      expect(matches[:verses]).to eq("17,19, 21")
    end
  end

  describe "matching multiple chapters and verses" do
    xit "matches scriptures multiple capters and verses" do
      scriptures.push "John 1:1; 17:21"

      expect(matches[:verses]).to eq("1:1; 17:21")
    end
  end
end
