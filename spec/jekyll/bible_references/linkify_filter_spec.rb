# frozen_string_literal: true

RSpec.describe Jekyll::BibleReferences::LinkifyFilter do
  subject(:filter) { described_class.new(input.join, context, result) }

  let(:context) do
    {
      "bible_references_link_template" => "to?q=%{QUERY}"
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

  it "linkifies a text element element" do
    scripture = "1 Corinthians 15:1"
    input.push("<p>")
    input.push(scripture.gsub(/\s/, ""))
    input.push("</p>")

    encoded = ERB::Util.url_encode(scripture)
    link = "to?q=#{encoded}"

    expect(html).to eq("<p><a href=\"#{link}\">1 Corinthians 15:1</a></p>")
  end

  it "does not linkifies a text that is are inside a link" do
    link = "<a href=\"#{link}\"><span>1 Corinthians 15:1</span></a>"

    input.push(link)

    expect(html).to eq(link)
  end
end
