class NavMenuItem
  attr_reader :label, :navigation_path

  def initialize(label:, navigation_path:)
    @label = label
    @navigation_path = navigation_path
  end
end
