# frozen_string_literal: true

require_relative "bible_references/version"
require_relative "bible_references/linkify_filter"
require_relative "bible_references/scripture_pattern"

require "html/pipeline"

module Jekyll
  module BibleReferences
    BODY_START_TAG = "<body"
    OPENING_BODY_TAG_REGEX = /<body(.*?)>\s*/m.freeze

    class << self
      def linkify(page)
        if page.output.include? BODY_START_TAG
          head, opener, tail  = page.output.partition(OPENING_BODY_TAG_REGEX)
          body_content, *rest = tail.partition("</body>")

          processed_markup = process_body(body_content, page)
          page.output = [head, opener, processed_markup, rest.join].join
          return
        end

        page.output = process_body(page.output, page)
      end

      private

      def process_body(_body, page)
        context = create_context(page)
        result = HTML::Pipeline.new([LinkifyFilter], context).call(page.output)
        result[:output].to_s
      end

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
