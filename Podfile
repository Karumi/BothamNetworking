workspace 'BothamNetworking.xcworkspace'
project 'BothamNetworking.xcodeproj'
use_frameworks!

def framework_pods
	pod "Result", '4.1.0'
end

def testing_pods
    pod "Nimble", '7.3.2'
    pod "Nocilla"
end

target 'BothamNetworking' do
	platform :ios, '8.0'
	framework_pods
	testing_pods
end

target 'BothamNetworkingTests' do
    platform :ios, '8.0'
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
