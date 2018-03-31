Pod::Spec.new do |s|
  s.name         = "KRTournamentView"
  s.version      = "1.0.1"
  s.summary      = "A flexible tournament bracket."
  s.description  = "KRTournamentView is a flexible tournament bracket that can respond to the various structure on iOS."
  s.homepage     = "https://github.com/krimpedance/KRTournamentView"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "krimpedance" => "krimpedance@gmail.com" }
  s.requires_arc = true

  s.ios.deployment_target = '8.0'

  s.source       = { :git => "https://github.com/krimpedance/KRTournamentView.git", :tag => s.version.to_s }
  s.source_files = "KRTournamentView/**/*.swift"
end
