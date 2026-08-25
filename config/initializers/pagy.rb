# Pagy — see kos/decisions/rails-datatable-pagy-turbo-frame-pattern.md and
# kos/decisions/rails-pagination-and-batch-export-processing.md. Sitewide
# default page size; individual controllers can override with
# `pagy(collection, limit: n)` if a screen needs a different count.
Pagy::OPTIONS[:limit] = 20

Pagy::OPTIONS.freeze
