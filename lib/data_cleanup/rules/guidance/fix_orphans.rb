# frozen_string_literal: true

module DataCleanup

  module Rules

    # Fix blank org on GuidanceGroup
    module Guidance

      class FixOrphans < Rules::Base

        def description
          "#{@debug_mode ? 'Finding' : 'Destroying'} orphaned Guidances"
        end

        def call
          destroy_orphans(::Guidance, 'guidance_groups')
        end

      end

    end

  end

end
