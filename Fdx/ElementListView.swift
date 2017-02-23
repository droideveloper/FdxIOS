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

class ElementListView: AbstractViewController<IElementListPresenter>,
IElementListView, LogDelegate {
	
	private let margin: CGFloat = 8;
	
	private var fabAddButton: FabButton!;
	private var progressView: UIActivityIndicatorView!;
	private var elementListView: UITableView!;
	
	func prepareView() {
		elementListView = UITableView(frame: .zero, style: .plain);
		elementListView.register(ElementViewHolder.self, forCellReuseIdentifier: ElementViewHolder.kIdentifier);
		
		elementListView.backgroundView = nil;
		elementListView.backgroundColor = Color.grey.lighten3;
		//footer
		elementListView.tableFooterView = UIView(frame: .zero);
		//divider
		elementListView.separatorStyle = .singleLine;
		elementListView.separatorColor = Color.grey.lighten3;
		
		elementListView.allowsMultipleSelection = false;
		//dataSource
		elementListView.dataSource = presenter?.dataSource;
		elementListView.delegate = presenter?.delegate;
		//layout view
		view.layout(elementListView)
			.edges(top: 1, left: 1, bottom: 1, right: 1);
		//progress
		progressView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge);
		progressView.color = application?.colorAccent;
		//layout view
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
			let homeUp = IconButton(image: Material.icon(.ic_menu), tintColor: .white);
			homeUp.addTarget(presenter, action: #selector(presenter?.click(_:)), for: .touchUpInside);
			toolbar.leftViews = [homeUp];
			toolbar.rightViews = [];
			
			toolbar.title = title;
			toolbar.titleLabel.textColor = .white;
			toolbar.titleLabel.textAlignment = .left;
		}
	}
	
	func notifyDataChanged() {
		elementListView.reloadData();
	}
	
	func notifyItemsRemoved(_ items: [IndexPath]) {
		elementListView.deleteRows(at: items, with: .left);
	}
	
	func notifyItemsInserted(_ items: [IndexPath]) {
		elementListView.insertRows(at: items, with: .automatic);
	}
	
	func showProgress() {
		progressView?.startAnimating();
	}
	
	func hideProgress() {
		progressView?.stopAnimating();
	}
	
	func showDialog(_ viewController: UIViewController) {
		self.present(viewController, animated: true);
	}
	
	func dismissDialog() {
		self.dismiss(animated: true, completion: nil);
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
		return true;
	}
	
	func getClassTag() -> String {
		return String(describing: ElementListView.self);
	}
}
