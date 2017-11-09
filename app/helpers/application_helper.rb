module ApplicationHelper
  include ActionView::Helpers::NumberHelper

  #####################
  #  DISPLAY HELPERS  #
  #####################
    def time_to_s(time, string="%b %e, %Y")
      time.present? ? time.strftime(string) : nil
    end

    def number_to_fee(val, placeholder="N/A", format="$%n%u")
      number_to_human(val, units: :fee, format: format) || placeholder
    end

    def semantic_bip(object, attribute, options={})
      best_in_place object, attribute, 
        class: 'ui form', 
        inner_class: 'ui fluid input',
        display_as: options[:display_as],
        activator: "[bip-id=#{object.id}] [bip-attr=#{attribute}]"
    end
    
    def datalist_tag(id, options)
      content_tag(:datalist, "", id: id) do
        options.map{ |option| content_tag(:option, "", value: option) }.reduce(:+)
      end
    end

  ##################
  #  MATH HELPERS  #
  ##################

    def sum(arr)
      arr.inject(0){ |sum, x| sum + x.to_f }
    end

    def multiple_of_two?(n)
      valid_num = 1
      while valid_num < n
        valid_num = valid_num << 1
        return true if n == valid_num
      end
      return false
    end

  ##################
  #  MISC HELPERS  #
  ##################

    def str_to_bool(string)
      string == "true"
    end
end
