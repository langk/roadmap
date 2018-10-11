# frozen_string_literal: true

module DataCleanup

  module Rules

    module Plan

      class FixRequiredField < Rules::Base

        def description
          "#{@debug_mode ? 'Finding' : 'Fixing'} empty required fields on Plan"
        end

        def call
          fix_blank_field(::Plan, 'title', "My plan")
        end

      end

    end

  end

end
