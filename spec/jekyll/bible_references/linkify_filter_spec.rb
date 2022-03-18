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

  def body(string)
    "<body>#{string}</body>"
  end

  def p(string)
    "<p>#{string}</p>"
  end

  it "is an HTML::Pipeline::Filter" do
    expect(filter).to be_a(HTML::Pipeline::Filter)
  end

  it "does nothing if the document has no content" do
    expect(filter.call.to_s).to eql("")
  end

  it "linkifies a scripture references inside body" do
    scripture = "1 Corinthians 15:1"
    input.push(body(p(scripture.gsub(/\s/, ""))))

    encoded = ERB::Util.url_encode(scripture)
    link = "to?q=#{encoded}"

    expect(html).to include("<p><a href=\"#{link}\">1 Corinthians 15:1</a></p>")
  end

  it "does not linkify a scripture references outside body" do
    scripture = "1 Corinthians 15:1"

    input.push(p(scripture.gsub(/\s/, "")))

    expect(html).to eq(input.join)
  end

  it "does not linkifies a text that is are inside a link" do
    link = body("<a href=\"#{link}\"><span>1 Corinthians 15:1</span></a>")

    input.push(link)

    expect(html).to eq(input.join)
  end

  it "does not linkifies a text that is are a script tag" do
    link = body("<script>1 Corinthians 15:1</script>")

    input.push(link)

    expect(html).to eq(input.join)
  end
end
