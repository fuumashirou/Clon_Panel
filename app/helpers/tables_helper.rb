module TablesHelper
  def qr_image code, args = {}
    size = args.has_key?(:size) ? args[:size] : "150x150"
    url = "https://chart.googleapis.com/chart?cht=qr&chl=#{u(code)}&choe=UTF-8&chld=H|1&chs=#{size}"
    if args.has_key?(:image) && args[:image] == false
      return url
    else
      return image_tag(url)
    end
  end
end
