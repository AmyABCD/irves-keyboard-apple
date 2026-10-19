#!/usr/bin/env python3
"""
Generates IrvesKeyboard.xcodeproj/project.pbxproj and shared xcscheme
for building Irves Keyboard on macOS / iOS / CI runners.
"""

import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
PROJECT_DIR = BASE_DIR / "IrvesKeyboard.xcodeproj"
PROJECT_DIR.mkdir(exist_ok=True)
SCHEMES_DIR = PROJECT_DIR / "xcshareddata" / "xcschemes"
SCHEMES_DIR.mkdir(parents=True, exist_ok=True)

PBXPROJ_CONTENT = """// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 54;
	objects = {

/* Begin PBXBuildFile section */
		AA0100010000000000000001 /* IrvesKeyboardApp.swift in Sources */ = {isa = PBXBuildFile; fileRef = AA0100010000000000000011 /* IrvesKeyboardApp.swift */; };
		AA0100020000000000000001 /* ContentView.swift in Sources */ = {isa = PBXBuildFile; fileRef = AA0100020000000000000011 /* ContentView.swift */; };
		AA0100030000000000000001 /* stickers.json in Resources */ = {isa = PBXBuildFile; fileRef = AA0100030000000000000011 /* stickers.json */; };
		AA0100040000000000000001 /* Stickers in Resources */ = {isa = PBXBuildFile; fileRef = AA0100040000000000000011 /* Stickers */; };
		AA0100050000000000000001 /* IrvesKeyboardExtension.appex in Embed App Extensions */ = {isa = PBXBuildFile; fileRef = AA0200000000000000000001 /* IrvesKeyboardExtension.appex */; settings = {ATTRIBUTES = (RemoveHeadersOnCopy, ); }; };
		AA0200010000000000000001 /* KeyboardViewController.swift in Sources */ = {isa = PBXBuildFile; fileRef = AA0200010000000000000011 /* KeyboardViewController.swift */; };
		AA0200030000000000000001 /* stickers.json in Resources */ = {isa = PBXBuildFile; fileRef = AA0100030000000000000011 /* stickers.json */; };
		AA0200040000000000000001 /* Stickers in Resources */ = {isa = PBXBuildFile; fileRef = AA0100040000000000000011 /* Stickers */; };
/* End PBXBuildFile section */

/* Begin PBXContainerItemProxy section */
		AA0100000000000000000099 /* PBXContainerItemProxy */ = {
			isa = PBXContainerItemProxy;
			containerPortal = AA0000000000000000000001 /* Project object */;
			proxyType = 1;
			remoteGlobalIDString = AA0200000000000000000000;
			remoteInfo = IrvesKeyboardExtension;
		};
/* End PBXContainerItemProxy section */

/* Begin PBXCopyFilesBuildPhase section */
		AA0100050000000000000099 /* Embed App Extensions */ = {
			isa = PBXCopyFilesBuildPhase;
			buildActionMask = 2147483647;
			dstPath = "";
			dstSubfolderSpec = 13;
			files = (
				AA0100050000000000000001 /* IrvesKeyboardExtension.appex in Embed App Extensions */,
			);
			name = "Embed App Extensions";
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXCopyFilesBuildPhase section */

/* Begin PBXFileReference section */
		AA0100000000000000000001 /* IrvesKeyboard.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = IrvesKeyboard.app; sourceTree = BUILT_PRODUCTS_DIR; };
		AA0100010000000000000011 /* IrvesKeyboardApp.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = IrvesKeyboardApp.swift; sourceTree = "<group>"; };
		AA0100020000000000000011 /* ContentView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ContentView.swift; sourceTree = "<group>"; };
		AA0100050000000000000011 /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
		AA0200000000000000000001 /* IrvesKeyboardExtension.appex */ = {isa = PBXFileReference; explicitFileType = "wrapper.app-extension"; includeInIndex = 0; path = IrvesKeyboardExtension.appex; sourceTree = BUILT_PRODUCTS_DIR; };
		AA0200010000000000000011 /* KeyboardViewController.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = KeyboardViewController.swift; sourceTree = "<group>"; };
		AA0200050000000000000011 /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
		AA0100030000000000000011 /* stickers.json */ = {isa = PBXFileReference; lastKnownFileType = text.json; path = stickers.json; sourceTree = "<group>"; };
		AA0100040000000000000011 /* Stickers */ = {isa = PBXFileReference; lastKnownFileType = folder; path = Stickers; sourceTree = "<group>"; };
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		AA0100000000000000000002 /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
		AA0200000000000000000002 /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		AA0000000000000000000002 = {
			isa = PBXGroup;
			children = (
				AA0000000000000000000010 /* IrvesKeyboard */,
				AA0000000000000000000020 /* IrvesKeyboardExtension */,
				AA0000000000000000000030 /* Shared */,
				AA0000000000000000000040 /* Products */,
			);
			sourceTree = "<group>";
		};
		AA0000000000000000000010 /* IrvesKeyboard */ = {
			isa = PBXGroup;
			children = (
				AA0100010000000000000011 /* IrvesKeyboardApp.swift */,
				AA0100020000000000000011 /* ContentView.swift */,
				AA0100050000000000000011 /* Info.plist */,
			);
			path = IrvesKeyboard;
			sourceTree = "<group>";
		};
		AA0000000000000000000020 /* IrvesKeyboardExtension */ = {
			isa = PBXGroup;
			children = (
				AA0200010000000000000011 /* KeyboardViewController.swift */,
				AA0200050000000000000011 /* Info.plist */,
			);
			path = IrvesKeyboardExtension;
			sourceTree = "<group>";
		};
		AA0000000000000000000030 /* Shared */ = {
			isa = PBXGroup;
			children = (
				AA0100030000000000000011 /* stickers.json */,
				AA0100040000000000000011 /* Stickers */,
			);
			path = Shared;
			sourceTree = "<group>";
		};
		AA0000000000000000000040 /* Products */ = {
			isa = PBXGroup;
			children = (
				AA0100000000000000000001 /* IrvesKeyboard.app */,
				AA0200000000000000000001 /* IrvesKeyboardExtension.appex */,
			);
			name = Products;
			sourceTree = "<group>";
		};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		AA0100000000000000000000 /* IrvesKeyboard */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = AA0100000000000000000014 /* Build configuration list for PBXNativeTarget "IrvesKeyboard" */;
			buildPhases = (
				AA0100000000000000000003 /* Sources */,
				AA0100000000000000000002 /* Frameworks */,
				AA0100000000000000000004 /* Resources */,
				AA0100050000000000000099 /* Embed App Extensions */,
			);
			buildRules = (
			);
			dependencies = (
				AA0100000000000000000098 /* PBXTargetDependency */,
			);
			name = IrvesKeyboard;
			productName = IrvesKeyboard;
			productReference = AA0100000000000000000001 /* IrvesKeyboard.app */;
			productType = "com.apple.product-type.application";
		};
		AA0200000000000000000000 /* IrvesKeyboardExtension */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = AA0200000000000000000014 /* Build configuration list for PBXNativeTarget "IrvesKeyboardExtension" */;
			buildPhases = (
				AA0200000000000000000003 /* Sources */,
				AA0200000000000000000002 /* Frameworks */,
				AA0200000000000000000004 /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = IrvesKeyboardExtension;
			productName = IrvesKeyboardExtension;
			productReference = AA0200000000000000000001 /* IrvesKeyboardExtension.appex */;
			productType = "com.apple.product-type.app-extension";
		};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		AA0000000000000000000001 /* Project object */ = {
			isa = PBXProject;
			attributes = {
				BuildIndependentTargetsInParallel = 1;
				LastUpgradeCheck = 1500;
				TargetAttributes = {
					AA0100000000000000000000 = {
						CreatedOnToolsVersion = 15.0;
					};
					AA0200000000000000000000 = {
						CreatedOnToolsVersion = 15.0;
					};
				};
			};
			buildConfigurationList = AA0000000000000000000004 /* Build configuration list for PBXProject "IrvesKeyboard" */;
			compatibilityVersion = "Xcode 14.0";
			developmentRegion = mn;
			hasScannedForEncodings = 0;
			knownRegions = (
				mn,
				en,
				Base,
			);
			mainGroup = AA0000000000000000000002;
			productRefGroup = AA0000000000000000000040 /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				AA0100000000000000000000 /* IrvesKeyboard */,
				AA0200000000000000000000 /* IrvesKeyboardExtension */,
			);
		};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		AA0100000000000000000004 /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				AA0100030000000000000001 /* stickers.json in Resources */,
				AA0100040000000000000001 /* Stickers in Resources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
		AA0200000000000000000004 /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				AA0200030000000000000001 /* stickers.json in Resources */,
				AA0200040000000000000001 /* Stickers in Resources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		AA0100000000000000000003 /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				AA0100010000000000000001 /* IrvesKeyboardApp.swift in Sources */,
				AA0100020000000000000001 /* ContentView.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
		AA0200000000000000000003 /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				AA0200010000000000000001 /* KeyboardViewController.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXSourcesBuildPhase section */

/* Begin PBXTargetDependency section */
		AA0100000000000000000098 /* PBXTargetDependency */ = {
			isa = PBXTargetDependency;
			target = AA0200000000000000000000 /* IrvesKeyboardExtension */;
			targetProxy = AA0100000000000000000099 /* PBXContainerItemProxy */;
		};
/* End PBXTargetDependency section */

/* Begin XCBuildConfiguration section */
		AA0000000000000000000005 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_TESTABILITY = YES;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"$(inherited)",
				);
				IPHONEOS_DEPLOYMENT_TARGET = 15.0;
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				MTL_FAST_MATH = YES;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = iphoneos;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
				SWIFT_VERSION = 5.0;
			};
			name = Debug;
		};
		AA0000000000000000000006 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				GCC_NO_COMMON_BLOCKS = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 15.0;
				MTL_ENABLE_DEBUG_INFO = NO;
				MTL_FAST_MATH = YES;
				SDKROOT = iphoneos;
				SWIFT_COMPILATION_MODE = wholemodule;
				SWIFT_OPTIMIZATION_LEVEL = "-O";
				SWIFT_VERSION = 5.0;
				VALIDATE_PRODUCT = YES;
			};
			name = Release;
		};
		AA0100000000000000000015 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = "";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = IrvesKeyboard/Info.plist;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = mn.orkhon.irveskeyboard;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Debug;
		};
		AA0100000000000000000016 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = "";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = IrvesKeyboard/Info.plist;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = mn.orkhon.irveskeyboard;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Release;
		};
		AA0200000000000000000015 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = "";
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = IrvesKeyboardExtension/Info.plist;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
					"@executable_path/../../Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = mn.orkhon.irveskeyboard.extension;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SKIP_INSTALL = YES;
				SWIFT_EMIT_LOC_STRINGS = YES;
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Debug;
		};
		AA0200000000000000000016 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = "";
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = IrvesKeyboardExtension/Info.plist;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
					"@executable_path/../../Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = mn.orkhon.irveskeyboard.extension;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SKIP_INSTALL = YES;
				SWIFT_EMIT_LOC_STRINGS = YES;
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Release;
		};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		AA0000000000000000000004 /* Build configuration list for PBXProject "IrvesKeyboard" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				AA0000000000000000000005 /* Debug */,
				AA0000000000000000000006 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		AA0100000000000000000014 /* Build configuration list for PBXNativeTarget "IrvesKeyboard" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				AA0100000000000000000015 /* Debug */,
				AA0100000000000000000016 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		AA0200000000000000000014 /* Build configuration list for PBXNativeTarget "IrvesKeyboardExtension" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				AA0200000000000000000015 /* Debug */,
				AA0200000000000000000016 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
/* End XCConfigurationList section */

	};
	rootObject = AA0000000000000000000001 /* Project object */;
}
"""

XCSCHEME_CONTENT = """<?xml version="1.0" encoding="UTF-8"?>
<Scheme
   LastUpgradeVersion = "1500"
   version = "1.7">
   <BuildAction
      parallelizeBuildables = "YES"
      buildImplicitDependencies = "YES">
      <BuildActionEntries>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "YES"
            buildForProfiling = "YES"
            buildForArchiving = "YES"
            buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "AA0100000000000000000000"
               BuildableName = "IrvesKeyboard.app"
               BlueprintName = "IrvesKeyboard"
               ReferencedContainer = "container:IrvesKeyboard.xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <TestAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      shouldUseLaunchSchemeArgsEnv = "YES">
      <Testables>
      </Testables>
   </TestAction>
   <LaunchAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      launchStyle = "0"
      useCustomWorkingDirectory = "NO"
      ignoresPersistentStateOnLaunch = "NO"
      debugDocumentVersioning = "YES"
      debugServiceExtension = "internal"
      allowLocationSimulation = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "AA0100000000000000000000"
            BuildableName = "IrvesKeyboard.app"
            BlueprintName = "IrvesKeyboard"
            ReferencedContainer = "container:IrvesKeyboard.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </LaunchAction>
   <ProfileAction
      buildConfiguration = "Release"
      shouldUseLaunchSchemeArgsEnv = "YES"
      savedToolIdentifier = ""
      useCustomWorkingDirectory = "NO"
      debugDocumentVersioning = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "AA0100000000000000000000"
            BuildableName = "IrvesKeyboard.app"
            BlueprintName = "IrvesKeyboard"
            ReferencedContainer = "container:IrvesKeyboard.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </ProfileAction>
   <AnalyzeAction
      buildConfiguration = "Debug">
   </AnalyzeAction>
   <ArchiveAction
      buildConfiguration = "Release"
      revealArchiveInOrganizer = "YES">
   </ArchiveAction>
</Scheme>
"""

(PROJECT_DIR / "project.pbxproj").write_text(PBXPROJ_CONTENT.strip() + "\n", encoding="utf-8")
(SCHEMES_DIR / "IrvesKeyboard.xcscheme").write_text(XCSCHEME_CONTENT.strip() + "\n", encoding="utf-8")

print("Generated IrvesKeyboard.xcodeproj successfully!")
