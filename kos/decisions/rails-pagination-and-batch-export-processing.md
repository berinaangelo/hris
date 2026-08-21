---
title: rails-pagination-and-batch-export-processing
tags: [hris, rails, backend, performance]
date: 2026-08-21
---

Standing conventions for pagination and batch/export processing in the
HRIS project.

**Pagination — sanitize params before they ever reach the query.**
Never trust `params[:page]`/`params[:per_page]` directly — clamp both:
page must be a positive integer (reject/normalize `-1`, `0`, garbage),
page size gets clamped to a sane max regardless of what's requested
(reject e.g. `9999999999`). Shared as a controller concern since every
paginated list (People Directory, Payroll Runs, Reports) needs the same
guard:

```ruby
module Paginatable
  extend ActiveSupport::Concern

  DEFAULT_PAGE_SIZE = 25
  MAX_PAGE_SIZE = 100

  private

  def safe_page
    page = params[:page].to_i
    page.positive? ? page : 1
  end

  def safe_page_size
    size = params[:per_page].to_i
    return DEFAULT_PAGE_SIZE if size <= 0
    size.clamp(1, MAX_PAGE_SIZE)
  end
end
```

**Pagination gem: Pagy**, not Kaminari — leaner/faster, fits the
project's general bias toward the lighter option (same reasoning as
[[rails-activejob-solid-queue-for-background-work|Solid Queue over
Sidekiq]]).

```ruby
class PeopleController < ApplicationController
  include Paginatable

  def index
    @pagy, @employees = pagy(Employee.all, page: safe_page, items: safe_page_size)
  end
end
```

**Batch processing / exports — streaming vs job-based batching,
depending on size.** Never load a full table with `Model.all.each` —
always `find_each`/`find_in_batches`/`in_batches` (batch_size 1000
default) for anything touching a potentially-large table.

- **Streaming** (inline, synchronous) — for exports fast enough to
  complete within a normal request (roughly a few seconds). Write
  straight to `response.stream` while iterating in batches, so memory
  stays flat and the download starts immediately.
- **Query-based batching via a background job** — for genuinely large
  or slow exports (a full payroll register, a year-end statutory
  summary, multi-year headcount/turnover reports). Use a Solid Queue
  job (per
  [[rails-activejob-solid-queue-for-background-work]]) that walks the
  data in batches, builds the file, then notifies the user with a
  download link once done — avoids web request timeouts entirely.

```ruby
# streaming example
def export
  response.headers["Content-Type"] = "text/csv"
  response.headers["Content-Disposition"] = "attachment; filename=employees.csv"

  self.response_body = Enumerator.new do |csv|
    csv << CSV.generate_line(["Name", "Start Date"])
    Employee.find_each(batch_size: 500) do |employee|
      csv << CSV.generate_line([employee.full_name, employee.start_date])
    end
  end
end
```

**How to decide which:** if it's small/fast enough for a normal
request, stream inline for faster UX; if it's a genuinely large report
or could run long, push it to a background job — same threshold logic
already used for
[[rails-activejob-solid-queue-for-background-work|what goes through
ActiveJob]].
