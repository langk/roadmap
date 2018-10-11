# frozen_string_literal: true

module DataCleanup

  module Rules

    module Plan

      class FixOrphans < Rules::Base

        def description
          "#{@debug_mode ? 'Finding' : 'Destroying'} orphaned Plans"
        end

        def call
          destroy_orphans(::Plan, 'templates')
        end

      end

    end

  end

end
