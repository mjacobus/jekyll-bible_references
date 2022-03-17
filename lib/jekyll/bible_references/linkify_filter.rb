# frozen_string_literal: true

require "html/pipeline"

module Jekyll
  module BibleReferences
    # The number of the book, like in:
    # - 1 John
    # - 5 Mose (German)
    PREFIX = /<?book_prefix>([1-5])/.freeze

    class LinkifyFilter < HTML::Pipeline::Filter
      def call
        doc.search("//text()").each do |node|
          replace_node(node)
        end
      end

      private

      def replace_node(node)
        html = node.to_html

        replacement = replace_text.gsub(matcher) do |match|
          prefix = Regexp.last_match(1)
          node.replace(linkify(match, prefix))
        end

        if html != replacement
          node.replace(html)
        end

        node
      end

      def matcher
        @matcher ||= /([1-3])/
      end
    end
  end
end
