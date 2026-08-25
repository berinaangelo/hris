# Bulma is vendored unmodified at app/assets/stylesheets/bulma/ (npm
# bulma@1.0.4's own sass/ — see kos/decisions/ui/bulma-vendored-prefixed.md).
# Its own source still uses Sass's old if() syntax, which newer Dart Sass
# flags as deprecated ([if-function]) on every build.
#
# --quiet-deps doesn't help here: Dart Sass only treats a @use'd
# stylesheet as a "dependency" when it's pulled in from a load path
# outside the entrypoint's own directory tree, and Bulma is vendored
# right alongside application.scss under the same app/assets/stylesheets
# root, so it doesn't qualify (confirmed by testing the flag directly —
# warnings persisted). --silence-deprecation targets the deprecation ID
# itself instead, so it silences these warnings regardless of where the
# file offering them lives, without touching the vendored Bulma source
# or hiding deprecation warnings from this app's own SCSS.
Rails.application.config.dartsass.build_options << "--silence-deprecation=if-function"
