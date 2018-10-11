# frozen_string_literal: true

module DataCleanup

  module Rules

    module Section

      class FixOrphans < Rules::Base

        def description
          "#{@debug_mode ? 'Finding' : 'Destroying'} orphaned Sections"
        end

        def call
          destroy_orphans(::Section, 'phases')
        end

      end

    end

  end

end
