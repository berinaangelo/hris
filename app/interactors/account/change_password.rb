module Account
  class ChangePassword
    include Interactor

    def call
      employee = context.employee

      unless employee.authenticate(context.current_password)
        context.fail!(message: "Current password is incorrect.")
        return
      end

      if context.new_password != context.new_password_confirmation
        context.fail!(message: "New password and confirmation don't match.")
        return
      end

      employee.update!(password: context.new_password, password_changed_at: Time.current)
    end
  end
end
