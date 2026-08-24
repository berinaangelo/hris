# Inline Lucide-style icons — single stroke, no fill, per
# kos/decisions/ui/iconography-lucide.md. Only the fixed set actually
# used across the Batch 1 auth/account pages (login, password
# recovery, account settings, my profile) is defined here; add more
# paths as later pages need them.
module IconsHelper
  ICON_PATHS = {
    building: '<path d="M4 21V7a2 2 0 0 1 2-2h4v16"/><path d="M14 21V11a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v10"/><path d="M9 9h.01M9 13h.01M9 17h.01"/>',
    mail: '<rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 6-10 7L2 6"/>',
    lock: '<rect x="3" y="11" width="18" height="10" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>',
    eye: '<path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7-11-7-11-7Z"/><circle cx="12" cy="12" r="3"/>',
    "arrow-right": '<path d="M5 12h14M13 6l6 6-6 6"/>',
    "circle-check": '<path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><path d="m22 4-10 10-3-3"/>',
    clock: '<circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/>',
    "check-circle": '<circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/>',
    x: '<path d="M18 6 6 18M6 6l12 12"/>',
    pencil: '<path d="M12 20h9"/><path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z"/>',
    download: '<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><path d="M7 10l5 5 5-5M12 15V3"/>',
    file: '<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><path d="M14 2v6h6"/>'
  }.freeze

  # lucide_icon(:mail, class: "icon-left", stroke_width: 1.75)
  def lucide_icon(name, stroke_width: 1.75, **html_options)
    paths = ICON_PATHS.fetch(name) { raise ArgumentError, "unknown icon: #{name}" }
    classes = [ "", html_options.delete(:class) ].compact.join(" ").strip
    attrs = { viewBox: "0 0 24 24", fill: "none", stroke: "currentColor", "stroke-width": stroke_width,
              "stroke-linecap": "round", "stroke-linejoin": "round" }.merge(html_options)
    attrs[:class] = classes if classes.present?
    tag.svg(paths.html_safe, **attrs)
  end
end
