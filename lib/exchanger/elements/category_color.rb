module Exchanger
  # A Category Color represents an attribute on the category element that describes the color of the category.
  # The application should use a value from -1 to 24. If any other value is used, the application must interpret
  # that value as if it were -1 (no color). The RGB values provided here are the basic colors for the category.
  # Applications can choose to display the color category differently.
  #
  # https://msdn.microsoft.com/en-us/library/ee203806(v=exchg.80).aspx
  class CategoryColor
    # Exchange Color Value to RGB.
    # Note: These colors were set to match the Outlook 2016 colors which are different than the EWS documentation.
    COLORS = {
      -1 => [255, 255,255],   # No color
      0 => [240, 125, 136],   # Red
      1 => [255, 140, 0],     # Orange
      2 => [254, 203, 111],   # Peach
      3 => [255, 241, 0],     # Yellow
      4 => [95, 190, 125],    # Green
      5 => [51, 186, 177],    # Teal
      6 => [163, 179, 103],   # Olive
      7 => [85, 171, 229],    # Blue
      8 => [168, 149, 226],   # Purple
      9 => [228, 139, 181],   # Maroon
      10 => [185, 192, 203],  # Steel
      11 => [76, 89, 110],    # Dark steel
      12 => [171, 171, 171],  # Gray
      13 => [102, 102, 102],  # Dark gray
      14 => [71, 71, 71],     # Black
      15 => [145, 10, 25],    # Dark red
      16 => [206, 75, 40],    # Dark orange
      17 => [153, 110, 54],   # Dark peach
      18 => [176, 169, 35],   # Dark yellow
      19 => [2, 104, 2],      # Dark green
      20 => [28, 99, 103],    # Dark teal
      21 => [92, 106, 34],    # Dark olive
      22 => [37, 64, 105],    # Dark blue
      23 => [86, 38, 133],    # Dark purple
      24 => [128, 39, 93],    # Dark maroon
    }.freeze

    attr_reader :value, :red, :green, :blue

    def initialize(value)
      @value = COLORS.keys.include?(value) ? value : -1
      rgb = COLORS[@value]
      @red = rgb[0]
      @green = rgb[1]
      @blue = rgb[2]
    end

    def css_color
      "rgb(#{red}, #{green}, #{blue});"
    end
  end
end
