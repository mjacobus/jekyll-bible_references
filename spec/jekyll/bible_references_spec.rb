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
        "destination" => fixtures_dir("_site")
      )
    )
  end
  let(:config_overrides) { {} }

  before do
    site.reset
    site.read
    # (site.pages | posts | site.docs_to_write).each { |p| p.content.strip! }
    site.render
  end

  it "is not nil" do
    expect(described_class::VERSION).not_to be_nil
  end

  describe ".linkify" do
    let(:post) { find_by_title(site.posts, "I'm a post") }

    it ".linkify" do
      expect(post.output).to match(/Biblified/)
    end
  end
end
