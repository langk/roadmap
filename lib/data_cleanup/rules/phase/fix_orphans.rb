# frozen_string_literal: true

module DataCleanup

  module Rules

    module Phase

      class FixOrphans < Rules::Base

        def description
          "#{@debug_mode ? 'Finding' : 'Destroying'} orphaned Phases"
        end

        def call
          destroy_orphans(::Phase, 'templates')
        end

      end

    end

  end

end
