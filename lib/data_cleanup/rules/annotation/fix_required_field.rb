# frozen_string_literal: true

module DataCleanup

  module Rules

    # Fix blank org on GuidanceGroup
    module Annotation

      class FixRequiredField < Rules::Base

        def description
          "#{@debug_mode ? 'Finding' : 'Fixing'} empty required fields on Annotation"
        end

        def call
          fix_blank_field(::Annotation, 'type', 1)
          destroy_record_with_blank_field(::Annotation, 'text')
        end

      end

    end

  end

end
