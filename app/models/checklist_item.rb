class ChecklistItem < ApplicationRecord
  belongs_to :employee

  enum :checklist_type, { onboarding: 0, offboarding: 1 }

  validates :item_key, presence: true
  validates :position, presence: true

  def completed?
    completed_at.present?
  end

  def complete!
    update!(completed_at: Time.current)
  end

  # Per-item-key convenience predicates on Employee (employee.
  # employment_contract_signed?, employee.equipment_returned?, ...) —
  # generated once here rather than hand-written per key, per
  # kos/decisions/rails-metaprogramming-for-repetitive-methods.md's own
  # canonical example (a set of near-identical methods differing only by
  # an interpolated key). Reuses the already-loaded `checklist_items`
  # association (`.detect`, not `.exists?`) so repeated calls don't
  # trigger N extra queries per employee, per
  # kos/decisions/rails-orm-performance-n-plus-one-and-indexes.md.
  module EmployeePredicates
    extend ActiveSupport::Concern

    class_methods do
      def checklist_item_predicates(*keys)
        keys.each do |key|
          define_method("#{key}?") do
            checklist_items.detect { |item| item.item_key == key }&.completed? || false
          end
        end
      end
    end
  end
end
