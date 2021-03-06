fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios alpha
```
fastlane ios alpha
```
Builds alpha release and upload to Crashlytics
### ios beta
```
fastlane ios beta
```
Builds beta release and upload to Crashlytics
### ios trial
```
fastlane ios trial
```
Builds trial release and upload to Testflight
### ios store
```
fastlane ios store
```

### ios screenshots
```
fastlane ios screenshots
```

### ios upload_metadata
```
fastlane ios upload_metadata
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
