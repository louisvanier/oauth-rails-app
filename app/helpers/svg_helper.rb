module SvgHelper
  def inline_svg(path)
    File.open("app/assets/images/#{path}.svg", 'rb') do |file|
      raw file.read
    end
  end
end