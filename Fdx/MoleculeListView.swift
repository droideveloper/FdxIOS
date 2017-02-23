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

class MoleculeListView: AbstractViewController<IMoleculeListPresenter>,
	IMoleculeListView, LogDelegate {
	
	private let margin: CGFloat = 8;
	
	private var fabAddButton: FabButton!;
	private var progressView: UIActivityIndicatorView!;
	private var moleculeListView: UITableView!;
	
	func prepareView() {
		moleculeListView = UITableView(frame: .zero, style: .plain);
		//register viewHolder for this specific view and its data model
		
		moleculeListView.backgroundView = nil;
		moleculeListView.backgroundColor = Color.grey.lighten3;
		//footer
		moleculeListView.tableFooterView = UIView(frame: .zero);
		//divider
		moleculeListView.separatorStyle = .singleLine;
		moleculeListView.separatorColor = .clear;
		
		moleculeListView.allowsMultipleSelection = false;
		
		moleculeListView.dataSource = presenter?.dataSource;
		moleculeListView.delegate = presenter?.delegate;
		
		view.layout(moleculeListView)
			.edges(top: 3, left: 3, bottom: 3, right: 3);
		
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
		moleculeListView.reloadData();
	}
	
	func notifyItemsInserted(_ at: [IndexPath]) {
		moleculeListView.insertRows(at: at, with: .automatic);
	}
	
	func notifyItemsRemvoved(_ at: [IndexPath]) {
		moleculeListView.deleteRows(at: at, with: .left);
	}
	
	func dismissDialogController(_ animated: Bool) {
		dismiss(animated: animated, completion: nil);
	}
	
	func displayDialogController(_ dialogController: UIViewController, _ animated: Bool) {
		present(dialogController, animated: animated, completion: nil);
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
		return String(describing: MoleculeListView.self);
	}
}
