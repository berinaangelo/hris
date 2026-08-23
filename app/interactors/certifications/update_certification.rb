module Certifications
  class UpdateCertification
    include Interactor

    def call
      if context.employee.nil?
        context.fail!(message: "Select a valid employee.")
        return
      end

      certification = context.certification
      certification.employee = context.employee
      certification.cert_name = context.cert_name
      certification.expiry_date = context.expiry_date

      if certification.save
        context.certification = certification
      else
        context.fail!(message: certification.errors.full_messages.to_sentence)
      end
    end
  end
end
