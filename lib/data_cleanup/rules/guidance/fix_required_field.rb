# frozen_string_literal: true

module DataCleanup

  module Rules

    # Fix blank org on GuidanceGroup
    module Guidance

      class FixRequiredField < Rules::Base

        def description
          "#{@debug_mode ? 'Finding' : 'Fixing'} empty required fields on Guidance"
        end

        def call
          fix_blank_field(::Guidance, 'published', false)
          destroy_record_with_blank_field(::Guidance, 'text')
        end

      end

    end

  end

end
