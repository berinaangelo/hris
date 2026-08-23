class CreateLeaveBalances < ActiveRecord::Migration[8.1]
  def change
    # A real, always-materialized rollup table — not a live-query
    # summary — because the Home dashboard hero and Time Off page both
    # need an O(1) "days remaining" read on nearly every page view. Full
    # rollup mechanics documented in
    # kos/decisions/schema/core-v1-schema.md; short version:
    #
    #   entitled_days is set once per employee/leave_type/year (policy
    #   not decided yet — flat default or accrual job, TBD).
    #
    #   used_days is updated by explicit Interactor steps
    #   (Leave::ApproveRequest / Leave::CancelApprovedRequest), never an
    #   AR callback, per rails-callback-objects-for-cache-busting.md.
    #
    #   remaining_days is never stored — always computed at read time as
    #   (entitled_days - used_days), to avoid a third number drifting.
    create_table :leave_balances do |t|
      t.references :employee, null: false, foreign_key: true
      t.references :leave_type, null: false, foreign_key: true
      t.integer :year, null: false

      t.decimal :entitled_days, precision: 5, scale: 2, null: false, default: 0
      t.decimal :used_days, precision: 5, scale: 2, null: false, default: 0

      # Optimistic locking — see rails-db-transactions-locking-idempotency.md
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end

    add_index :leave_balances, [:employee_id, :leave_type_id, :year],
              unique: true, name: "index_leave_balances_on_employee_type_year"
  end
end
