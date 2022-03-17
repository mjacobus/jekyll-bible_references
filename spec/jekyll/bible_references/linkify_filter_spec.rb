# frozen_string_literal: true

RSpec.describe Jekyll::BibleReferences::LinkifyFilter do
  subject(:filter) { described_class.new(input.join, context, result) }

  let(:context) do
    {
      "bible_references_link_template" => "to?{verse}"
    }
  end
  let(:input) { [] }
  let(:result) { {} }
  let(:html) { doc.to_s }
  let(:doc) { filter.call }

  it "is an HTML::Pipeline::Filter" do
    expect(filter).to be_a(HTML::Pipeline::Filter)
  end

  it "does nothing if the document has no content" do
    expect(filter.call.to_s).to eql("")
  end

  it "linkifies a simple test" do
    scripture = "1 Corinthians 15:1"
    input.push("<p>")
    input.push("Read #{scripture} and also #{scripture}.")
    input.push("</p>")

    escaped = ERB::Util.url_encode(scripture)

    expect(html).to include("Read <a href=\"to?q={escaped}\">1 Corinthians 15:1</a>")
    expect(html).to include("and also <a href=\"to?q={escaped}\">1 Corinthians 15:1</a>.")
  end
end
