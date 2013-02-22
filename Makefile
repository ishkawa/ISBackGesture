default:
	if [ -a Products ]; then rm -R Products; fi;
	mkdir -p Products/ISBackGesture
	xcodebuild -target ISBackGesture -sdk iphoneos -arch armv7 -arch armv7s clean build
	xcodebuild -target ISBackGesture -sdk iphonesimulator -arch i386 clean build
	xcrun lipo -create build/Release-iphonesimulator/libISBackGesture.a  build/Release-iphoneos/libISBackGesture.a -output Products/libISBackGesture.a
	cp ISBackGesture/*.h Products/ISBackGesture/
