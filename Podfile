workspace 'BothamNetworking.xcworkspace'
project 'BothamNetworking.xcodeproj'
use_frameworks!

def framework_pods
	pod "Result"
	pod "SwiftyJSON"
end

def testing_pods
    pod "Nimble"
    pod "Nocilla"
end

target 'BothamNetworking' do
	platform :ios, '8.0'
	framework_pods
	testing_pods
end

target 'BothamNetworkingTests' do
	framework_pods
	testing_pods
end

target 'BothamNetworkingCocoa' do
	platform :osx, '10.10'
	framework_pods
end

target 'BothamNetworkingCocoaTests' do
	platform :osx, '10.10'
	framework_pods
	testing_pods
end
