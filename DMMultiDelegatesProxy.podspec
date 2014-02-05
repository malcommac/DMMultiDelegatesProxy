Pod::Spec.new do |s|
  s.name         = "DMMultiDelegatesProxy"
  s.version      = "0.1.0"
  s.summary      = "Multiple delegate architecture made using NSProxy both for iOS and OSX"
  s.description  = <<-DESC
                    DMMultiDelegatesProxy is an NSProxy which allows you to set multiple delegates to any object. Provided example show how to register two classes for some UIScrollView's delegate events; it' pretty easy. A detailed intro is available [into this post](http://danielemargutti.com/in/multiple-delegates-in-objective-c/)
                   DESC
  s.homepage     = "http://danielemargutti.com/in/multiple-delegates-in-objective-c/"
  s.screenshots  = ""
  s.license      = 'MIT'
  s.author       = { "Daniele Margutti" => "me@danielemargutti.com" }
  s.source       = { :git => "https://github.com/malcommac/DMMultiDelegatesProxy.git", :tag => s.version.to_s }

  # s.platform     = :ios, '5.0'
  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'Classes/**/*.{h,m}'

  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
  s.public_header_files = 'Classes/**/*.h'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'
  # s.dependency 'JSONKit', '~> 1.4'
end
