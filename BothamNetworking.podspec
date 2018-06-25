Pod::Spec.new do |s|
    s.name = 'BothamNetworking'
    s.version = '3.0.0'
    s.swift_version = '4.1'
    s.license = 'Apache V2'
    s.summary = 'Networking Framework written in Swift'
    s.homepage = 'https://github.com/Karumi/BothamNetworking'
    s.social_media_url = 'http://twitter.com/goKarumi'
    s.authors = {'Karumi' => 'hello@karumi.com' }
    s.source = { :git => 'https://github.com/Karumi/BothamNetworking.git', :tag => s.version }

    s.ios.deployment_target = '8.0'
    s.osx.deployment_target = '10.10'

    s.source_files = 'BothamNetworking/*.swift'
    s.requires_arc = true

    s.dependency 'Result', '3.1.0'
    s.dependency 'SwiftyJSON'
end
