# frozen_string_literal: true

RSpec.describe Jekyll::BibleReferences do
  Jekyll.logger.log_level = :error

  let(:site) { Jekyll::Site.new(configs) }
  let(:configs) do
    Jekyll.configuration(
      config_overrides.merge(
        "skip_config_files" => false,
        "collections" => { "docs" => { "output" => true } },
        "source" => fixtures_dir,
        "destination" => fixtures_dir("_site"),
        "bible_references" => {
          "link_template" => "to?q=%{QUERY}"
        }
      )
    )
  end
  let(:config_overrides) { {} }

  before do
    site.reset
    site.read
    site.render
  end

  it "is not nil" do
    expect(described_class::VERSION).not_to be_nil
  end

  describe ".linkify" do
    let(:post) { find_by_title(site.posts, "I'm a post") }

    it ".linkify" do
      text = "Gênesis 1:1"
      encoded = ERB::Util.url_encode(text)
      url = "to?q=#{encoded}"
      link = "<a href=\"#{url}\">#{text}</a>"

      expect(post.output).to include(link)
    end
  end
end
