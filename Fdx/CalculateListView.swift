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

class CalculateListView: AbstractViewController<ICalculateListPresenter>,
	ICalculateListView, LogDelegate {
	
	static let homeAsUp = 0xFF;
	static let clearAll = 0xFD;
	static let visible  = 0xFC;
	
	private let margin: CGFloat = 8;
	
	private var fabAddButton: FabButton!;
	private var progressView: UIActivityIndicatorView!;
	private var calculateListView: UITableView!;
	
	func prepareView() {
		calculateListView = UITableView(frame: .zero, style: .plain);
		//register viewHolder
		calculateListView.backgroundView = nil;
		calculateListView.backgroundColor = Color.grey.lighten3;
		//not attachment
		calculateListView.tableFooterView = UIView(frame: .zero);
		//
		calculateListView.separatorStyle = .singleLine;
		calculateListView.separatorColor = .clear;
		
		calculateListView.allowsMultipleSelection = false;
		
		calculateListView.dataSource = presenter?.dataSource;
		calculateListView.delegate = presenter?.delegate;
		
		view.layout(calculateListView)
			.edges(top: 3, left: 3, bottom: 3, right: 3);
		
		progressView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge);
		progressView.color = application?.colorAccent;
		
		view.layout(progressView)
			.center();
		
		fabAddButton = FabButton(image: Material.icon(.ic_add), tintColor: .white);
		fabAddButton.backgroundColor = application?.colorAccent;
		fabAddButton.addTarget(presenter, action: #selector(presenter?.click(_:)), for: .touchUpInside);
		fabAddButton.depthPreset = .depth4;
		
		view.layout(fabAddButton)
			.size(CGSize(width: 48, height: 48))
			.bottomRight(bottom: margin, right: margin);
		
		view.backgroundColor = Color.grey.lighten2;
	}
	
	func prepareToolbar() {
		if let toolbar = toolbarController?.toolbar {
			let homeAsUp = IconButton(image: Material.icon(.ic_menu), tintColor: .white);
			homeAsUp.tag = CalculateListView.homeAsUp; // tag we use in presenter
			homeAsUp.addTarget(presenter, action: #selector(presenter?.click(_:)), for: .touchUpInside);
			toolbar.leftViews = [homeAsUp];
			
			let clearAll = IconButton(image: Material.icon(.ic_delete), tintColor: .white);
			clearAll.tag = CalculateListView.clearAll;// tag
			clearAll.addTarget(presenter, action: #selector(presenter?.click(_:)), for: .touchUpInside);
			
			let visible = IconButton(image: Material.icon(.ic_visibility), tintColor: .white);
			visible.tag = CalculateListView.visible;// tag
			visible.addTarget(presenter, action: #selector(presenter?.click(_:)), for: .touchUpInside);
			toolbar.rightViews = [clearAll, visible];
			
			toolbar.title = title;
			toolbar.titleLabel.textColor = .white;
			toolbar.titleLabel.textAlignment = .left;
		}
	}
	
	func notifyDataChanged() {
		calculateListView.reloadData();
	}
	
	func notifyItemsInserted(_ at: [IndexPath]) {
		calculateListView.insertRows(at: at, with: .automatic);
	}
	
	func notifyItemsRemvoved(_ at: [IndexPath]) {
		calculateListView.deleteRows(at: at, with: .left);
	}
	
	func displayDialogController(_ dialogController: UIViewController, _ animated: Bool) {
		present(dialogController, animated: animated, completion: nil);
	}
	
	func dismissDialogController(_ animated: Bool) {
		dismiss(animated: animated, completion: nil);
	}
	
	func showProgress() {
		progressView?.startAnimating();
	}
	
	func hideProgress() {
		progressView?.stopAnimating();
	}
	
	func showError(_ error: String, action actionText: String?, completed on: (() -> Void)?) {
		if let snackbar = snackbarController?.snackbar {
			snackbar.text = error;
			if let str = actionText {
				let button = Flat(title: str, tintColor: Color.red.base, callback: on);
				button.addTarget(self, action: #selector(hideError), for: .touchUpInside);
				snackbar.rightViews = [button];
			}
			_ = snackbarController?.animate(snackbar: .visible);
			_ = snackbarController?.animate(snackbar: .hidden, delay: 5);
		}
	}
	
	@objc func hideError() {
		if let snackbar = snackbarController?.snackbar {
			snackbar.layer.removeAllAnimations();
		}
		_ = snackbarController?.animate(snackbar: .hidden);
	}
	
	func isLogEnabled() -> Bool {
		#if DEBUG
			return true;
		#else
			return false;
		#endif
	}
	
	func getClassTag() -> String {
		return String(describing: CalculateListView.self);
	}
}
