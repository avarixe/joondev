module MyFifa
  class Fixture < Base
    belongs_to :competition

    serialize :home_score, Array
    serialize :away_score, Array

    %w(home away).each do |type|
      define_method "#{type}_score=" do |val|
        if val.is_a? Array
          write_attribute "#{type}_score", val
        else
          write_attribute "#{type}_score", val.split(",").map(&:strip)
        end
      end
    end
  end
end
