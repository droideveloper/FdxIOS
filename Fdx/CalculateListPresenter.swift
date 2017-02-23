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


import Foundation
import UIKit

import Core
import Material

class CalculateListPresenter: AbstractPresenter<ICalculateListView>,
	ICalculateListPresenter, LogDelegate {
	
	var dataSource: UITableViewDataSource? {
		get {
			return nil;
		}
	}
	
	var delegate: UITableViewDelegate? {
		get {
			return nil;
		}
	}
	
	var dbManager: IDatabaseManager?;
	
	func viewDidLoad() {
		view?.prepareView();
		view?.prepareToolbar();
	}
	
	func click(_ sender: Any) {
		if sender is IconButton {
			if let target = sender as? IconButton {
				switch target.tag {
					case CalculateListView.homeAsUp:
						BusManager.post(event: MenuActionEvent(isOpen: true));
						break;
					case CalculateListView.clearAll:
						//clear data to zero
						view?.notifyDataChanged();
						break;
					case CalculateListView.visible:
						//show dialog that holds data
						break;
					default:
						break;
				}
			}
		} else {
			//add thing
			let materialDialog = MaterialAlertController(title: "\n", message: nil, preferredStyle: .alert);
			materialDialog.positiveHandler = {
				print("positive Clicked");
			};
			materialDialog.negativeHandler = {
				print("negative Clicked");
			};
			view?.displayDialogController(materialDialog, true);
		}
	}
	
	func viewWillAppear(_ animated: Bool) { }
	func viewWillDisappear(_ animated: Bool) { }
	func didReceiveMemoryWarning() { }
	
	func isLogEnabled() -> Bool {
		#if DEBUG
			return true;
		#else
			return false;
		#endif
	}
	
	func getClassTag() -> String {
		return String(describing: CalculateListPresenter.self);
	}
}
