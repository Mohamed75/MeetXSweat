# Minimum iOS version
platform :ios, '9.0'

use_frameworks!
inhibit_all_warnings!

# List of dependencies for the application
def shared_pods
pod 'FBSDKCoreKit', '~> 4.15.1'
pod 'FBSDKLoginKit', '~> 4.15.1'
pod 'FBSDKShareKit', '~> 4.15.1'


pod 'Fabric'
pod 'Crashlytics'

pod 'TwitterKit'

pod 'LinkedinIOSHelper'

pod 'GoogleSignIn'

pod 'Alamofire', '~> 4.3'
pod 'AlamofireImage', '~> 3.1'


pod 'JTAppleCalendar', '~> 6.0'


pod 'Firebase/Core'
pod 'Firebase/Database'
pod 'Firebase/Auth'
pod 'Firebase/Storage'
pod 'Firebase/Messaging'

pod 'DrawerController', '~> 3.1'

pod 'JSQMessagesViewController'

pod 'PickerView'
end


target 'MeetXSweat' do
    shared_pods
end

target 'MeetXSweatProd' do
    shared_pods
end

target 'MeetXSweatTests' do
    shared_pods
    pod 'OHHTTPStubs/Swift'
end
