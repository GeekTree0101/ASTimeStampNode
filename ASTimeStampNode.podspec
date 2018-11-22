Pod::Spec.new do |s|
  s.name             = 'ASTimeStampNode'
  s.version          = '1.0.0'
  s.summary          = 'Tic Toc Tic Toc with Texture'

  s.description      = "ASTimeStampNode is Timer UI which created with texture."

  s.homepage         = 'https://github.com/Geektree0101/ASTimeStampNode'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Geektree0101' => 'h2s1880@gmail.com' }
  s.source           = { :git => 'https://github.com/Geektree0101/ASTimeStampNode.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '9.0'
  s.source_files = 'ASTimeStampNode/Classes/**/*'
  s.dependency 'Texture', '~> 2.7'
end
