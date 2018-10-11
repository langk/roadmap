# frozen_string_literal: true

module DataCleanup

  module Rules

    # Fix blank org on GuidanceGroup
    module GuidanceGroup

      class FixOrphans < Rules::Base

        def description
          "#{@debug_mode ? 'Finding' : 'Destroying'} orphaned GuidanceGroups"
        end

        def call
          destroy_orphans(::GuidanceGroup, 'orgs')
        end

      end

    end

  end

end
