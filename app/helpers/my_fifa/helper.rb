module MyFifa
  module Helper
    def time_to_s(time, string="%b %e, %Y")
      time.present? ? time.strftime(string) : nil
    end

    def responsive_cell_label(label)
      content_tag :div, label, class: 'ui responsive basic right pointing label'
    end

    def sum(arr)
      arr.inject(0){ |sum, x| sum + x.to_f }
    end
  end
end
