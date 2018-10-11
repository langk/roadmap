# frozen_string_literal: true

module DataCleanup

  module Rules

    module Note

      class FixOrphans < Rules::Base

        def description
          "#{@debug_mode ? 'Finding' : 'Destroying'} orphaned Notes"
        end

        def call
          destroy_orphans(::Note, 'answers')
          destroy_orphans(::Note, 'users')
        end

      end

    end

  end

end
