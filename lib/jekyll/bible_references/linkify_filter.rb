# frozen_string_literal: true

require "html/pipeline"

module Jekyll
  module BibleReferences
    class LinkifyFilter < HTML::Pipeline::Filter
      def call
        unless doc.is_a?(Nokogiri::HTML4::DocumentFragment)
          return doc
        end

        doc.search("body").each do |_body|
          replace_body_entries(doc)
        end

        doc
      end

      private

      def linkify(scripture)
        linkifier.linkify(scripture)
      end

      def linkifier
        @linkifier ||= context.fetch("linkifier") { DefaultLinkifier.new(context) }
      end

      def replace_body_entries(body)
        body.search(".//text() | text()").each do |node|
          if has_ancestor?(node, forbidden_ancestors)
            next
          end

          replace_node(node)
        end
      end

      def replace_node(node)
        html = node.to_html

        replacement = html.gsub(matcher) do |_original|
          match = Regexp.last_match
          text = [match[:prefix], match[:book], match[:verses]].join(" ").strip
          linkify(text)
        end

        node.replace(Nokogiri::HTML.fragment(replacement))
      end

      def forbidden_ancestors
        %w[a script]
      end

      def matcher
        @matcher ||= ScripturePattern.new
      end
    end
  end
end
