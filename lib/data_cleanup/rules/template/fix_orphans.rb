# frozen_string_literal: true

module DataCleanup

  module Rules

    module Template

      class FixOrphans < Rules::Base

        def description
          "#{@debug_mode ? 'Finding' : 'Destroying'} orphaned Templates"
        end

        def call
          destroy_orphans(::Template, 'orgs')

          # Handle Customizations whose customization_of is orphaned
          ids = ::Template.where("customization_of is not null and customization_of not in (?)", ::Template.all.pluck(:family_id)).pluck(:id)
          if !ids.empty? && !@debug_mode
            log("Setting customization_of to NULL for Template without matching parent template for ids: #{ids}")
            ::Template.where(id: ids).update_attributes(customization_of: nil)
          end

          msg = "  #{ids.count} Customizations with missing parent Template"
          rslt = " - customization_of #{@debug_mode ? 'will be' : 'were' } set to nil"
          DataCleanup.display "#{msg}#{ids.any? ? rslt : ''}", color: ids.any? ? :red : :green
        end

      end

    end

  end

end
