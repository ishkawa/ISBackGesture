equips `UIViewController` with recognizing "swipe to back".

## Requirements

- OS: iOS4 or later
- Arch: armv7, armv7s or i386

## Usage

import the header file.

```objectivec
#import <ISBackGesture/ISBackGesture.h>
```

to enable recognizing back gesture, set `backGestureEnabled` `YES`.

```objectivec
UIViewController *viewController = [[UIViewController alloc] init];
viewController.backGestureEnabled = YES;
```

to get the progress of backgesture, access `backProgress`.
```
float progress = viewController.backProgress;
```

## Installing

### CocoaPods

If you use CocoaPods, you can install ISBackGesture by inserting config below.
```
pod 'ISBackGesture', :git => 'https://github.com/ishkawa/ISBackGesture.git'
```

### Build from Source Code

#### Clone and Build

- `git clone https://github.com/ishkawa/ISBackGesture.git`
- `cd ISBackGesture`
- `make`


#### Copy files to your project

copy files under `Products/`

- `libISBackGesture.a`
- `ISBackGesture` (Header files)
- `ISBackGesture.bundle`

#### Link to QuartzCore.framework

open .xcodeproj -> "Build Phases" and add QuartzCore.framework in "Link Binary with Libraries".

#### Add Linker Flag

open .xcodeproj -> "Build Settings" and add `-ObjC` option into "Other Linker Flags".  
this config is required to load categories in a static library.

#### Add Header Search Path

open .xcodeproj -> Build Settings and add `$(SRCROOT)/` option into "Header Search Path".  
(If you copied ISBackGesture files into `$(SRCROOT)/Library`, add `$(SRCROOT)/Library`.)

## License

Copyright (c) 2013 Yosuke Ishikawa

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

