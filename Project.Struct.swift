import MKHProjGen

//===

let My =
(
    repoName: "MKHRequirement",
    deploymentTarget: "8.0",
    companyIdentifier: "khatskevich.maxim",
    developmentTeamId: "Maxim Khatskevich" // "UJA88X59XP"
)

let BundleId =
(
    fwk: "\(My.companyIdentifier).\(My.repoName)",
    tst: "\(My.companyIdentifier).\(My.repoName).Tst"
)

//===

let project = Project("Main") { p in
    
    p.configurations.all.override(
        
        "DEVELOPMENT_TEAM" <<< My.developmentTeamId,
        
        "SWIFT_VERSION" <<< "3.0",
        "VERSIONING_SYSTEM" <<< "apple-generic"
    )
    
    p.configurations.debug.override(
        
        "SWIFT_OPTIMIZATION_LEVEL" <<< "-Onone"
    )
    
    //---
    
    p.target(My.repoName, .iOS, .framework) { t in
        
        t.include("Src")
        
        //---
        
        t.configurations.all.override(
            
            "IPHONEOS_DEPLOYMENT_TARGET" <<< My.deploymentTarget,
            "PRODUCT_BUNDLE_IDENTIFIER" <<< BundleId.fwk,
            "INFOPLIST_FILE" <<< "Info/Fwk.plist",
            
            //--- iOS related:
            
            "SDKROOT" <<< "iphoneos",
            "TARGETED_DEVICE_FAMILY" <<< DeviceFamily.iOS.universal,
            
            //--- Framework related:
            
            "DEFINES_MODULE" <<< "NO",
            "SKIP_INSTALL" <<< "YES"
        )
        
        //---
    
        t.unitTests { ut in
            
            ut.include("Tst")
            
            //---
            
            ut.configurations.all.override(
            
                "PRODUCT_BUNDLE_IDENTIFIER" <<< BundleId.tst,
                "INFOPLIST_FILE" <<< "Info/Tst.plist",
                "FRAMEWORK_SEARCH_PATHS" <<< "$(inherited) $(BUILT_PRODUCTS_DIR)"
            )
        }
    }
}
