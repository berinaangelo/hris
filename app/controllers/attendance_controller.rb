class AttendanceController < ApplicationController
  def clock_in
    authorize :attendance, :clock_in?

    result = Attendance::RecordClockIn.call(employee: current_employee)
    redirect_to root_path, **(result.success? ? { notice: "Clocked in." } : { alert: result.message })
  end

  def clock_out
    authorize :attendance, :clock_out?

    result = Attendance::RecordClockOut.call(employee: current_employee)
    redirect_to root_path, **(result.success? ? { notice: "Clocked out." } : { alert: result.message })
  end
end
