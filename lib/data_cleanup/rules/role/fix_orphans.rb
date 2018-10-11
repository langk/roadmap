# frozen_string_literal: true

module DataCleanup

  module Rules

    module Role

      class FixOrphans < Rules::Base

        def description
          "#{@debug_mode ? 'Finding' : 'Destroying'} orphaned Roles"
        end

        def call
          destroy_orphans(::Role, 'plans')
          destroy_orphans(::Role, 'users')
        end

      end

    end

  end

end
