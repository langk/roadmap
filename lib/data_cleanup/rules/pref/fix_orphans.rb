# frozen_string_literal: true

module DataCleanup

  module Rules

    module Pref

      class FixOrphans < Rules::Base

        def description
          "#{@debug_mode ? 'Finding' : 'Destroying'} orphaned Prefs"
        end

        def call
          destroy_orphans(::Pref, 'users')
        end

      end

    end

  end

end
