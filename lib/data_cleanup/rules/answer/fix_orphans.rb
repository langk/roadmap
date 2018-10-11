# frozen_string_literal: true

module DataCleanup

  module Rules

    module Answer

      class FixOrphans < Rules::Base

        def description
          "#{@debug_mode ? 'Finding' : 'Destroying'} orphaned Answers"
        end

        def call
          destroy_orphans(::Answer, 'plans')
          destroy_orphans(::Answer, 'questions')

          # Try to set Answers with orphaned users to the owner
          counter = 0
          ::Answer.joins("LEFT OUTER JOIN users ON users.id = answers.user_id")
                  .where(users: { id: nil })
                  .includes(plan: { roles: :user }).each do |answer|

            if !@debug_mode
              if answer.plan.owner.present?
                log("Updating Answer##{answer.id} with user: #{answer.plan.owner}")
                answer.update(user: answer.plan.owner)
              elsif answer.plan.roles.any?
                user = answer.plan.roles.first.user
                log("Updating Answer##{answer.id} with user: #{user}")
                answer.update(user: user)
              else
                log("Destroying orphaned Answer##{answer.id}")
                answer.destroy
              end
            end
            counter += 1
          end

          msg = "  #{counter} Answers with missing User"
          rslt = " - user #{@debug_mode ? 'will be' : 'were' } set to the owner of the plan"
          DataCleanup.display "#{msg}#{counter > 0 ? rslt : ''}", color: counter > 0 ? :red : :green
        end

      end

    end

  end

end
