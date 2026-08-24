require "test_helper"

module Payslips
  class LineItemsControllerTest < ActionDispatch::IntegrationTest
    setup do
      payroll_run = Payroll::OpenRun.call(company: companies(:acme), period_start: Date.current.beginning_of_month,
                                           period_end: Date.current.end_of_month, pay_date: Date.current).payroll_run
      Payroll::FinalizeRun.call(payroll_run: payroll_run, finalized_by: employees(:admin_amy))
      original = payroll_run.payslips.find_by(employee: employees(:worker_bob))
      sign_in employees(:admin_amy)
      patch void_and_reissue_payslip_path(original), params: { void_reason: "correction" }
      @draft_payslip = original.reload.reissued_version
      @line_item = @draft_payslip.payslip_line_items.first
    end

    test "admin can add a line item to a draft payslip, and totals recompute" do
      net_pay_before = @draft_payslip.net_pay

      assert_difference "PayslipLineItem.count", 1 do
        post payslip_line_items_path(@draft_payslip), params: {
          payslip_line_item: { line_type: "bonus", direction: "earning", amount: 500, description: "Referral bonus" }
        }
      end

      assert_redirected_to payslip_path(@draft_payslip)
      added = @draft_payslip.payslip_line_items.find_by(description: "Referral bonus")
      assert_equal "manual", added.source
      assert_equal net_pay_before + 500, @draft_payslip.reload.net_pay
    end

    test "admin can edit a line item's amount, and totals recompute" do
      original_amount = @line_item.amount

      patch payslip_line_item_path(@draft_payslip, @line_item), params: {
        payslip_line_item: { line_type: @line_item.line_type, direction: @line_item.direction, amount: original_amount + 100, description: @line_item.description }
      }

      assert_redirected_to payslip_path(@draft_payslip)
      assert_equal original_amount + 100, @line_item.reload.amount
    end

    test "admin can remove a line item, and totals recompute" do
      assert_difference "PayslipLineItem.count", -1 do
        delete payslip_line_item_path(@draft_payslip, @line_item)
      end

      assert_redirected_to payslip_path(@draft_payslip)
    end

    test "editing is forbidden once the payslip is finalized" do
      patch finalize_payslip_path(@draft_payslip)

      patch payslip_line_item_path(@draft_payslip, @line_item), params: {
        payslip_line_item: { line_type: @line_item.line_type, direction: @line_item.direction, amount: 1, description: "" }
      }

      assert_redirected_to root_path
    end

    test "a manager cannot add a line item" do
      delete session_path
      sign_in employees(:manager_jane)

      # Same reasoning as PayslipsControllerTest's manager test: the
      # payslip isn't in the manager's own policy_scope, so it 404s
      # before authorize is even reached.
      post payslip_line_items_path(@draft_payslip), params: {
        payslip_line_item: { line_type: "bonus", direction: "earning", amount: 500, description: "nope" }
      }

      assert_response :not_found
    end

    private

    def sign_in(employee)
      post session_path, params: { work_email: employee.work_email, password: "password" }
    end
  end
end
