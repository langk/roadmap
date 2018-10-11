# frozen_string_literal: true

module DataCleanup

  module Rules

    # Fix blank org on GuidanceGroup
    module GuidanceGroup

      class FixRequiredField < Rules::Base

        def description
          "#{@debug_mode ? 'Finding' : 'Fixing'} empty required fields on GuidanceGroup"
        end

        def call
          fix_blank_field(::GuidanceGroup, 'optional_subset', false)
          fix_blank_field(::GuidanceGroup, 'published', false)

          counter = 0
          ::GuidanceGroup.where(name: [nil, ""]).each do |group|
            if group.org.present? && !@debug_mode
              log("setting name to match the Org abbreviation GuidanceGroup for ids: #{ids}")
              group.name = group.org.abbreviation || group.org.name
              group.save!
            end
            counter += 1
          end

          msg = "  #{counter} GuidanceGroups with empty name"
          rslt = " - Value #{@debug_mode ? 'will be' : 'were' } set to the Org abbreviation"
          DataCleanup.display "#{msg}#{counter > 0 ? rslt : ''}", color: counter > 0 ? :red : :green
        end

      end

    end

  end

end
