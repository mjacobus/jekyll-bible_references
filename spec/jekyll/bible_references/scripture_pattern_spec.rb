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
      scriptures.push "Gênesis 3:1-4"

      expect(matches[:book]).to eq("Gênesis")
    end
  end

  describe "matching verses" do
    it "matches scriptures with one space between book and verses" do
      scriptures.push "1 Corinthians 3:1-4"

      expect(matches[:verses]).to eq("3:1-4")
    end

    it "matches scriptures with two spaces between book and verses" do
      scriptures.push "1  Corinthians  3:1-4"

      expect(matches[:verses]).to eq("3:1-4")
    end

    it "matches scriptures with no spaces between book and verses" do
      scriptures.push "1Corinthians 3:1-4"

      expect(matches[:verses]).to eq("3:1-4")
    end

    it "matches scriptures with no spaces between book and verses" do
      scriptures.push "1 Corinthians3:1-4"

      expect(matches[:verses]).to eq("3:1-4")
    end

    it "matches scriptures with one verse" do
      scriptures.push "Genesis 3:1"

      expect(matches[:verses]).to eq("3:1")
    end

    it "matches scriptures with a single chapter" do
      scriptures.push "Jude 17"

      expect(matches[:verses]).to eq("17")
    end

    it "matches scriptures with a single chapter and multiple verses" do
      scriptures.push "Jude 17,19,21"

      expect(matches[:verses]).to eq("17,19,21")
    end

    it "matches scriptures with a single chapter and multiple verses, some with spaces in between" do
      scriptures.push "Jude 17,19, 21"

      expect(matches[:verses]).to eq("17,19, 21")
    end

    it "matches scriptures multiple capters and verses" do
      scriptures.push "John 1:1; 17:21"

      expect(matches[:verses]).to eq("1:1; 17:21")
    end
  end
end
