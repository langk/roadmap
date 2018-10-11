# frozen_string_literal: true

module DataCleanup

  module Rules

    module Theme

      class FixRequiredField < Rules::Base

        def description
          "#{@debug_mode ? 'Finding' : 'Fixing'} empty required fields on Theme"
        end

        def call
          fix_blank_field(::Theme, 'description', "Default Theme Description - Please change")
        end

      end

    end

  end

end
