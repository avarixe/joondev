module MyFifa
  module Helper
    def time_to_string(time, string)
      time.present? ? time.strftime(string) : nil
    end

    def sum(arr)
      arr.inject(0){ |sum, x| sum + x.to_f }
    end
  end
end
