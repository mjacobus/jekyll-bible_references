# frozen_string_literal: true

require_relative "bible_references/version"
require_relative "bible_references/linkify_filter"
require_relative "bible_references/scripture_pattern"

require "html/pipeline"

module Jekyll
  module BibleReferences
    class << self
      def linkify(page)
        context = create_context(page)
        page.output = HTML::Pipeline.new([LinkifyFilter], context).call(page.output)[:output].to_s
      end

      private

      def create_context(page)
        config = page.site.config
        references = config["bible_references"] ||= {}
        references.transform_keys do |key|
          "bible_references_#{key}"
        end
      end
    end
  end
end

if defined?(Jekyll::Page)
  Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
    Jekyll::BibleReferences.linkify(doc)
  end
end
