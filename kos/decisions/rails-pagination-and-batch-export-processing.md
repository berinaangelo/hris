---
title: rails-pagination-and-batch-export-processing
tags: [hris, rails, backend, performance]
date: 2026-08-21
---

Standing conventions for pagination and batch/export processing in the
HRIS project.

**Pagination gem: Pagy**, not Kaminari — leaner/faster, fits the
project's general bias toward the lighter option (same reasoning as
[[rails-activejob-solid-queue-for-background-work|Solid Queue over
Sidekiq]]).

**Sanitize params before they ever reach the query — Pagy 43.x
(the version actually pinned in Gemfile.lock) already does this
itself**, not via a hand-rolled concern. This doc originally sketched
a `Paginatable` concern targeting an older "classic" Pagy API before
any real page used the gem; the first real wiring (People Directory,
2026-08-25) confirmed the installed 43.x is a rewritten major version
with a different API, verified against the gem's own source
(`lib/pagy.rb`, `lib/pagy/toolbox/paginators/offset.rb`,
`apps/rails.ru`'s bundled demo controller):

- Controller: `include Pagy::Method` (added to `ApplicationController`
  so every future paginated list gets it for free), then
  `@pagy, @collection = pagy(collection, limit: n)` — same
  `[pagy, records]` return shape as classic Pagy.
- `page` is resolved from `params[:page]` automatically inside `pagy`
  itself (via an internal `Request` built from the current
  `request`) — no manual `page:`/`safe_page` needed.
- Pagy clamps `page` to `>= 1` and to the last valid page server-side
  regardless of what's requested, and only lets a *client-supplied*
  limit override the default if `max_limit:` is explicitly passed —
  which none of this app's pages do, since page size isn't exposed as
  a request param anywhere. The old `Paginatable` concern above was
  reinventing a guard Pagy already provides; don't add it back.
- A sitewide default page size is set once in
  `config/initializers/pagy.rb` (`Pagy::OPTIONS[:limit] = 20`), so a
  plain `pagy(collection)` is enough unless a specific screen needs a
  different count.
- `@pagy` exposes plain numeric attributes to build UI from — `page`,
  `pages`, `from`, `to`, `count`, `previous`, `next` — rather than the
  gem's own `series_nav`/`info_tag` view helpers, which ship default
  markup/CSS that wouldn't match this app's hand-built components.
  Hand-build the Prev/Next + "Showing X–Y of Z" bar per page, same as
  every other piece of UI in this app.

```ruby
class EmployeesController < ApplicationController
  def index
    @employees = Employee.all # filters applied first
    @pagy, @employees = pagy(@employees)
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
