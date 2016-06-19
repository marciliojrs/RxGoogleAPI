Pod::Spec.new do |s|
  s.name             = 'RxGoogleAPI'
  s.version          = '0.1.2'
  s.summary          = 'RxGoogleAPI it`s a framework to Sign In and use the Google API with RxSwift.'

  s.homepage         = 'https://github.com/marciliojrs/RxGoogleAPI'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Marcilio Junior' => 'marciliojrs@gmail.com' }
  s.source           = { :git => 'https://github.com/marciliojrs/RxGoogleAPI.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/marciliojrs'

  s.ios.deployment_target = '9.0'

  s.source_files = 'RxGoogleAPI/Classes/**/*'
  
  s.dependency 'Moya/RxSwift', '~> 6.5'
  s.dependency 'RxSwift', '~> 2.5'
  s.dependency 'RxCocoa', '~> 2.5'
  s.dependency 'RxBlocking', '~> 2.5'
  s.dependency 'OAuthSwift', '~> 0.5'
end
