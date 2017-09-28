module ApplicationHelper

  def time_to_s(time, string="%b %e, %Y")
    time.present? ? time.strftime(string) : nil
  end

  def responsive_cell_label(label)
    content_tag :div, label, class: 'ui responsive basic right pointing label'
  end

  def sum(arr)
    arr.inject(0){ |sum, x| sum + x.to_f }
  end

  def number_to_fee(val, placeholder="N/A", format="$%n%u")
    number_to_human(val, units: :fee, format: format, precision: 2) || placeholder
  end

  def semantic_bip(object, attribute, options={})
    best_in_place object, attribute, class: 'ui form', display_as: options[:display_as]
  end
end
