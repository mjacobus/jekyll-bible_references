# frozen_string_literal: true

require_relative "bible_references/version"

require "html/pipeline"

module Jekyll
  module BibleReferences
    class << self
      def linkify(page)
        page.output += "Biblified"
      end
    end
  end
end

if defined?(Jekyll::Page)
  Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
    Jekyll::BibleReferences.linkify(doc)
  end
end
