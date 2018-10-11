# frozen_string_literal: true

module DataCleanup

  module Rules

    module Template

      class FixRequiredField < Rules::Base

        def description
          "#{@debug_mode ? 'Finding' : 'Fixing'} empty required fields on Template"
        end

        def call
          fix_blank_field(::Template, 'locale', FastGettext.default_locale)
          fix_blank_field(::Template, 'title', 'DEFAULT TITLE')
        end

      end

    end

  end

end
