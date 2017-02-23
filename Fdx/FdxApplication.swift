/*
 * Fdx Copyright (C) 2016 Fatih.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
import UIKit

import Core
import Material
import Swinject
 
@UIApplicationMain
class FdxApplication: UIResponder, UIApplicationDelegate {
 	
 	var window: UIWindow?;
	
	var colorPrimary: UIColor?			= Color.indigo.base;
	var colorPrimaryDark: UIColor?	= Color.indigo.darken2;
	var colorAccent: UIColor?				= Color.pink.base;
	
	var injector: Assembler?;
	
 	func applicationDidFinishLaunching(_ application: UIApplication) {
		injector = try? Assembler(assemblies: [AppComponent()]);
		
		window = UIWindow(frame: Screen.bounds);
		if let window = window {			
			let navigationView = injector?.resolver.resolve(ICategoryListView.self) as! CategoryListView;
			let contentView = UITableViewController();
			
			window.rootViewController = FdxDrawerViewController(rootViewController: FdxToolbarViewController(rootViewController: contentView),
			                                                    leftViewController: navigationView, rightViewController: nil);
			window.makeKeyAndVisible();
		}
	}
}

//LogDelegate
extension FdxApplication: LogDelegate {
	
	func isLogEnabled() -> Bool {
		#if DEBUG
			return true;
		#else
			return false;
		#endif
	}
	
	func getClassTag() -> String {
		return String(describing: FdxApplication.self);
	}
}

//Application Shared
extension UIViewController {
	
	var application: FdxApplication? {
		get {
			if let app = UIApplication.shared.delegate as? FdxApplication {
				return app;
			}
			return nil;
		}
	}
	
} 
