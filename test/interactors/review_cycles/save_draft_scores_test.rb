require "test_helper"

module ReviewCycles
  class SaveDraftScoresTest < ActiveSupport::TestCase
    test "saves partial scores without requiring every KPI to be scored" do
      review_cycle = review_cycles(:alice_awaiting_scoring)
      kpi_entry = kpi_entries(:alice_kpi_1)

      result = ReviewCycles::SaveDraftScores.call(
        review_cycle: review_cycle,
        kpi_scores_params: { kpi_entry.id.to_s => { "actual" => "8 open bugs", "score" => "4" } },
        manager_comment: "Great progress, one KPI still pending."
      )

      assert result.success?
      assert_equal "8 open bugs", kpi_entry.reload.actual
      assert_equal 4, kpi_entry.score
      assert_nil kpi_entries(:alice_kpi_2).reload.score
      assert_equal "Great progress, one KPI still pending.", review_cycle.reload.manager_comment
    end

    test "moves an in_progress cycle to awaiting_scoring on first save" do
      review_cycle = review_cycles(:carol_in_progress)

      result = ReviewCycles::SaveDraftScores.call(review_cycle: review_cycle, kpi_scores_params: {}, manager_comment: nil)

      assert result.success?
      assert review_cycle.reload.awaiting_scoring?
    end
  end
end
