module ApplicationHelper
  def number_to_fee(val, placeholder="N/A", format="$%n%u")
    number_to_human(val, units: :fee, format: format, precision: 2) || placeholder
  end
end
