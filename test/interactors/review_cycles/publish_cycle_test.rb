require "test_helper"

module ReviewCycles
  class PublishCycleTest < ActiveJob::TestCase
    test "publishes once every KPI is scored, and notifies the employee" do
      review_cycle = review_cycles(:alice_awaiting_scoring)
      alice_kpi_1 = kpi_entries(:alice_kpi_1)
      alice_kpi_2 = kpi_entries(:alice_kpi_2)

      assert_enqueued_with(job: CyclePublishedNotifierJob) do
        result = ReviewCycles::PublishCycle.call(
          review_cycle: review_cycle,
          kpi_scores_params: {
            alice_kpi_1.id.to_s => { "actual" => "8 open bugs", "score" => "4" },
            alice_kpi_2.id.to_s => { "actual" => "Shipped on time", "score" => "5" }
          },
          manager_comment: "Great cycle.",
          outcome: nil
        )

        assert result.success?
      end

      review_cycle.reload
      assert review_cycle.published?
      assert review_cycle.published_at.present?
    end

    test "fails without raising when a KPI is left unscored" do
      review_cycle = review_cycles(:alice_awaiting_scoring)
      alice_kpi_1 = kpi_entries(:alice_kpi_1)

      result = ReviewCycles::PublishCycle.call(
        review_cycle: review_cycle,
        kpi_scores_params: { alice_kpi_1.id.to_s => { "actual" => "8 open bugs", "score" => "4" } },
        manager_comment: nil,
        outcome: nil
      )

      assert result.failure?
      assert_not review_cycle.reload.published?
    end

    test "requires an outcome to publish a PIP" do
      review_cycle = review_cycles(:nora_pip_published)
      review_cycle.update!(status: :awaiting_scoring, outcome: nil, published_at: nil)

      result = ReviewCycles::PublishCycle.call(
        review_cycle: review_cycle,
        kpi_scores_params: {},
        manager_comment: nil,
        outcome: nil
      )

      assert result.failure?
    end

    test "is idempotent against double-publish" do
      review_cycle = review_cycles(:bob_published_regular)
      original_published_at = review_cycle.published_at

      result = ReviewCycles::PublishCycle.call(
        review_cycle: review_cycle, kpi_scores_params: {}, manager_comment: nil, outcome: nil
      )

      assert result.success?
      assert_equal original_published_at, review_cycle.reload.published_at
    end
  end
end
