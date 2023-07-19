#
#  Be sure to run `pod spec lint AAMultiRowCollectionViewLayout.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "AAMultiRowCollectionViewLayout"
  spec.version      = "0.0.1"
  spec.summary      = "A custom layout for UICollectionView"

  spec.description  = <<-DESC
  A collectionview layout supporting multiple scroll behaviour for each section and supporting multiple rows in section with horizontal scrolling.
                       DESC

  spec.homepage     = "https://github.com/azharashiq178/AAMultiRowCollectionViewLayout"
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "Muhammad Azher" => "azharashiq178@gmail.com" }
  spec.platform     = :ios
  spec.platform     = :ios, "13.0"
  spec.ios.deployment_target = "13.0"
  spec.swift_version = "4.2"
  spec.source       = { :git => "https://github.com/azharashiq178/AAMultiRowCollectionViewLayout.git", :tag => "#{spec.version}" }

  spec.source_files  = "AAMultiRowCollectionViewLayout/**/*.{h,m,swift}"

end
