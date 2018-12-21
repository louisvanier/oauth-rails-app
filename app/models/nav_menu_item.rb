class NavMenuItem
  attr_reader :label, :navigation_path, :category

  def initialize(label:, navigation_path:, category: nil)
    @label = label
    @navigation_path = navigation_path
    @category = category
  end
end
