Pod::Spec.new do |s|
  s.name             = "WSLogger"
  s.version          = "1.0.0"
  s.summary          = "An iOS logger where it's possible to extend the log functionality"
  s.homepage         = "https://github.com/whitesmith/WSLogger"
  s.license          = 'MIT'
  s.author           = { "Ricardo Pereira" => "m@ricardopereira.eu" }
  s.source           = { :git => "https://github.com/whitesmith/WSLogger.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/whitesmithco'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'WSLogger/*.{h}', 'Source/**/*.{h,swift}'
end