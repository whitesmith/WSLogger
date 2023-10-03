Pod::Spec.new do |s|
  s.name             = "WSLogger"
  s.version          = "3.2.0"
  s.summary          = "An extensible iOS logger on top of OSLog"
  s.homepage         = "https://github.com/whitesmith/WSLogger"
  s.license          = 'MIT'
  s.author           = { "Ricardo Pereira" => "m@ricardopereira.eu" }
  s.source           = { :git => "https://github.com/whitesmith/WSLogger.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/whitesmithco'

  s.platform     = :ios, '12.0'
  s.requires_arc = true
  s.swift_version = '5.0'

  s.source_files = 'WSLogger/*.{h}', 'Source/**/*.{h,swift}'
end
