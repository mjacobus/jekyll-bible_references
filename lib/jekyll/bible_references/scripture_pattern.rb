# frozen_string_literal: true

# https://stackoverflow.com/questions/22254746/bible-verse-regex
module Jekyll
  module BibleReferences
    class ScripturePattern < Regexp
      def initialize
        super(pattern)
      end

      private

      def pattern
        /#{prefix}#{maybe_spaces}#{book}#{maybe_spaces}#{verses}/
      end

      def prefix
        /(?<prefix>\d*)/
      end

      def book
        /(?<book>[[:alpha:]]+)/
      end

      def verses
        /(?<verses>\d{0,3}:?[0-9,\-\s]+)/
      end

      def maybe_spaces
        /(\s+)?/
      end
    end
  end
end
