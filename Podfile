workspace 'BothamNetworking.xcworkspace'
project 'BothamNetworking.xcodeproj'
use_frameworks!

def testing_pods
    pod "Nimble"
    pod "OHHTTPStubs/Swift"
end

def app_development_pods
	pod 'SwiftLint'
end

target 'BothamNetworking' do
	platform :ios, '8.0'
	app_development_pods
end

target 'BothamNetworkingTests' do
  platform :ios, '8.0'
  testing_pods
end

target 'BothamNetworkingCocoaTests' do
	platform :osx, '10.10'
	testing_pods
end
