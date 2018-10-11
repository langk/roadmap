# frozen_string_literal: true

module DataCleanup

  module Rules

    module OrgIdentifier

      class FixOrphans < Rules::Base

        def description
          "#{@debug_mode ? 'Finding' : 'Destroying'} orphaned OrgIdentifiers"
        end

        def call
          destroy_orphans(::OrgIdentifier, 'orgs')
          destroy_orphans(::OrgIdentifier, 'identifier_schemes')
        end

      end

    end

  end

end
