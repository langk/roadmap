#

module DataCleanup

  module Rules

    # Base class for rules to clean invalid database records
    class Base

      def initialize(debug_mode = true)
        @debug_mode = debug_mode
      end

      def log(message)
        DataCleanup.logger.info(message)
      end

      # Description of the rule and how it's fixing the data
      def description
        self.class.name.humanize
      end

      # Run this rule and fix data in the database.
      def call
        raise NotImplementedError, "Please define call() in #{self}"
      end

      def fix_blank_field(clazz, field, default_value)
        ids = find_blank_fields(clazz, field)
        if !ids.empty? && !@debug_mode
          log(".. Setting #{clazz.name}.#{field} = #{default_value} for ids: #{ids.inspect}")
          clazz.where(id: ids).update_attributes(field.to_sym => default_value)
        end

        msg = "  #{ids.count} #{clazz.name.pluralize} with empty #{field}"
        rslt = " - Values #{@debug_mode ? 'will be' : 'were' } set to #{default_value}"
        DataCleanup.display "#{msg}#{ids.any? ? rslt : ''}", color: ids.any? ? :red : :green
        if default_value == false && ids.any?
          DataCleanup.display "    *note that 'false' boolean values may be included in the above results", color: :red
        end
      end

      def destroy_record_with_blank_field(clazz, field)
        ids = find_blank_fields(clazz, field)
        if !ids.empty? && !@debug_mode
          log(".. Destroying #{clazz.name}.#{field} that is empty for ids: #{ids.inspect}")
          clazz.destroy(ids)
        end

        msg = "  #{ids.count} #{clazz.name.pluralize} with empty #{field}"
        rslt = " - Records #{@debug_mode ? 'will be' : 'were' } destroyed"
        DataCleanup.display "#{msg}#{ids.any? ? rslt : ''}", color: ids.any? ? :red : :green
      end

      def destroy_orphans(clazz, assocation)
        ids = clazz.joins("LEFT OUTER JOIN #{assocation} \
                           ON #{assocation}.id = #{clazz.name.tableize}.#{assocation.singularize}_id")
                   .where(assocation.to_sym => { id: nil }).pluck(:id)
        if !ids.empty? && !@debug_mode
          log("Destroying #{clazz.name} without #{assocation.singularize.capitalize}: #{ids}")
          clazz.destroy(ids)
        end

        msg = "  #{ids.count} #{clazz.name.pluralize} with missing #{assocation.singularize.capitalize}"
        rslt = " - Records #{@debug_mode ? 'will be' : 'were' } destroyed"
        DataCleanup.display "#{msg}#{ids.any? ? rslt : ''}", color: ids.any? ? :red : :green
      end

      private

      def find_blank_fields(clazz, field)
        ids = clazz.where(field.to_sym => [nil, ""]).pluck(:id)
        unless ids.empty?
          log(".. Found #{clazz.name}.#{field} to be empty for ids: #{ids.inspect}")
        end
        ids
      end

    end

  end

end
