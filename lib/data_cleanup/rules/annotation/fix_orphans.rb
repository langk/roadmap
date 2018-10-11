# frozen_string_literal: true

module DataCleanup

  module Rules

    module Annotation

      class FixOrphans < Rules::Base

        def description
          "#{@debug_mode ? 'Finding' : 'Destroying'} orphaned Annotations"
        end

        def call
          destroy_orphans(::Annotaion, 'orgs')
          destroy_orphans(::Annotaion, 'questions')
        end

      end

    end

  end

end
