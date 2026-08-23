require "test_helper"

class ReviewCycleMailerTest < ActionMailer::TestCase
  test "opened_email goes to the employee's work email" do
    review_cycle = review_cycles(:carol_in_progress)

    email = ReviewCycleMailer.opened_email(review_cycle)

    assert_equal [ employees(:worker_carol).work_email ], email.to
    assert_match "performance review", email.subject
  end

  test "opened_email calls out a PIP cycle" do
    review_cycle = review_cycles(:nora_pip_published)

    email = ReviewCycleMailer.opened_email(review_cycle)

    assert_match "PIP", email.subject
  end

  test "published_email goes to the employee's work email" do
    review_cycle = review_cycles(:bob_published_regular)

    email = ReviewCycleMailer.published_email(review_cycle)

    assert_equal [ employees(:worker_bob).work_email ], email.to
    assert_match "#{review_cycle.overall_rating.round(1)}/5", email.body.to_s
  end
end
