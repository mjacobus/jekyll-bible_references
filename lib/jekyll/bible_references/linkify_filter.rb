# frozen_string_literal: true

require "html/pipeline"

module Jekyll
  module BibleReferences
    class LinkifyFilter < HTML::Pipeline::Filter
      DEFAULT_LINK_TEMPLATE = "https://www.jw.org/pt/busca/?q=%{QUERY}&link=%2Fresults%2FT%2Fbible%3Fsort%3Drel%26q%3D"

      def call
        unless doc.is_a?(Nokogiri::HTML4::DocumentFragment)
          return doc
        end

        doc.search("body").each do |body|
          replace_body_entries(body)
        end

        doc
      end

      private

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
          "<a href=\"#{resolve_link(text)}\">#{text}</a>"
        end

        node.replace(Nokogiri::HTML.fragment(replacement))
      end

      def forbidden_ancestors
        %w[a script]
      end

      def matcher
        @matcher ||= ScripturePattern.new
      end

      def resolve_link(text)
        text = ERB::Util.url_encode(text)
        link.sub("%{QUERY}", text)
      end

      def link
        @link ||= context["bible_references_link_template"] || DEFAULT_LINK_TEMPLATE
      end
    end
  end
end
