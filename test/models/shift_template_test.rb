require "test_helper"

class ShiftTemplateTest < ActiveSupport::TestCase
  test "requires name, start_time, and end_time" do
    shift_template = ShiftTemplate.new(company: companies(:acme))

    assert_not shift_template.valid?
    assert_includes shift_template.errors[:name], "can't be blank"
    assert_includes shift_template.errors[:start_time], "can't be blank"
    assert_includes shift_template.errors[:end_time], "can't be blank"
  end

  test "cannot be destroyed while attendance records reference it" do
    shift_template = shift_templates(:day_shift)

    assert_not shift_template.destroy
    assert_includes shift_template.errors[:base].join, "attendance record"
    assert ShiftTemplate.exists?(shift_template.id)
  end

  test "destroying it nullifies employees' assignment instead of blocking" do
    shift_template = shift_templates(:night_shift)
    employee = employees(:worker_bob)
    employee.update!(shift_template: shift_template)

    assert shift_template.destroy

    assert_nil employee.reload.shift_template_id
  end
end
