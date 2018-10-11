# frozen_string_literal: true

module DataCleanup

  module Rules

    module Question

      class FixOrphans < Rules::Base

        def description
          "#{@debug_mode ? 'Finding' : 'Destroying'} orphaned Questions"
        end

        def call
          destroy_orphans(::Question, 'sections')

          # Set orphaned QuestionFormats to 'Text Area'
          ids = ids = ::Question.joins("LEFT OUTER JOIN question_formats \
                                        ON question_formats.id = questions.question_format_id")
                                .where(question_formats: { id: nil }).pluck(:id)
          if !ids.empty? && !@debug_mode
            text_area = QuestionFormat.find(0)
            log("Setting question_format to '#{text_area.title}' for Questions without a matching QuestionFormat for ids: #{ids}")
            ::Question.where(id: ids).update_attributes(question_format: text_area)
          end

          msg = "  #{ids.count} Questions with missing QuestionFormat"
          rslt = " - question_format #{@debug_mode ? 'will be' : 'were' } set to #{text_area.title}"
          DataCleanup.display "#{msg}#{ids.any? ? rslt : ''}", color: ids.any? ? :red : :green
        end

      end

    end

  end

end
