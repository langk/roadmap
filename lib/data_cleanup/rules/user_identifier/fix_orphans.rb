# frozen_string_literal: true

module DataCleanup

  module Rules

    module UserIdentifier

      class FixOrphans < Rules::Base

        def description
          "#{@debug_mode ? 'Finding' : 'Destroying'} orphaned UserIdentifiers"
        end

        def call
          destroy_orphans(::UserIdentifier, 'users')
        end

      end

    end

  end

end
