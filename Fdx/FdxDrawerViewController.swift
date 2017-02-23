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

import Material
import Core
import RxSwift

class FdxDrawerViewController: NavigationDrawerController {

	private var subscription: Disposable?;
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated);
		subscription = BusManager.register(on: { [weak weakSelf = self] (event: EventDelegate) in
			if let event = event as? MenuActionEvent {
				if event.isOpen {
					weakSelf?.openLeftView();
				} else {
					weakSelf?.closeLeftView();
				}
			} else if let event = event as? ContentActionEvent {
				if let newController = event.viewController {
					weakSelf?.newContentView(newController);
				}
			}
		});
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated);
		if let subscription = subscription {
			subscription.dispose();
		}
	}
	
	override func prepare() {
		super.prepare();
	}
	
	private func newContentView(_ viewController: UIViewController) {
		if let toolbarController = rootViewController as? FdxToolbarViewController {
			toolbarController.transition(to: viewController);
		}
		//this is safety mechanism that we close menu like that
		if isLeftViewOpened {
			closeLeftView();
		}
	}
}
