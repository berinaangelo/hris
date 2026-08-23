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

      if certification.save
        context.certification = certification
      else
        context.fail!(message: certification.errors.full_messages.to_sentence)
      end
    end
  end
end
