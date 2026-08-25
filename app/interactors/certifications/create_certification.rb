module Certifications
  class CreateCertification
    include Interactor

    def call
      if context.employee.nil?
        context.fail!(message: "Select a valid employee.")
        return
      end

      certification = Certification.new(context.certification_params)
      certification.employee = context.employee
      # Set before save (not only on success) so a failed create still
      # hands the controller back the validated, error-carrying instance
      # to re-render with — same fix as Employees::CreateRecord.
      context.certification = certification

      unless certification.save
        context.fail!(message: certification.errors.full_messages.to_sentence)
      end
    end
  end
end
