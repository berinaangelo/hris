module ReviewCycles
  class CreateCycle
    include Interactor

    def call
      if context.employee.nil?
        context.fail!(message: "Select a valid employee.")
        return
      end

      review_cycle = ReviewCycle.new(
        employee: context.employee,
        cycle_type: context.cycle_type,
        start_date: context.start_date,
        end_date: context.end_date,
        status: :in_progress
      )

      if review_cycle.save
        context.review_cycle = review_cycle
      else
        context.fail!(message: review_cycle.errors.full_messages.to_sentence)
      end
    end

    def rollback
      context.review_cycle&.destroy
    end
  end
end
