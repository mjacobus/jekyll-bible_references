# frozen_string_literal: true

module Jekyll
  module BibleReferences
    class DefaultLinkifier
      DEFAULT_LINK_TEMPLATE = "https://www.jw.org/pt/busca/?q=%{QUERY}&link=%2Fresults%2FT%2Fbible%3Fsort%3Drel%26q%3D"

      def initialize(context = {})
        @context = context
      end

      def linkify(scripture)
        "<a href=\"#{resolve_link(scripture)}\">#{scripture}</a>"
      end

      private

      def resolve_link(text)
        text = ERB::Util.url_encode(text)
        link.sub("%{QUERY}", text)
      end

      def link
        @link ||= @context["bible_references_link_template"] || DEFAULT_LINK_TEMPLATE
      end
    end
  end
end
