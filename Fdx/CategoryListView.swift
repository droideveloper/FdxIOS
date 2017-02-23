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

class CategoryListView: AbstractViewController<ICategoryListPresenter>,
	ICategoryListView, LogDelegate {
	
	private let height: CGFloat = Screen.scale * 60;
	
	private var progressView: UIActivityIndicatorView!;
	private var categoryListView: UITableView!;
	
	func prepareView() {		
		let headerView = UIImageView(image: UIImage(named: "chemistry"));
		view.layout(headerView)
			.horizontally(left: 0, right: 0)
			.height(height);
		//list
		categoryListView = UITableView(frame: .zero, style: .plain);
		//register
		categoryListView.register(CategoryViewHolder.self, forCellReuseIdentifier: CategoryViewHolder.kIdentifier);
		//view related
		categoryListView.backgroundView = nil;
		categoryListView.backgroundColor = Color.grey.darken3;
		//footer
		categoryListView.tableFooterView = UIView(frame: .zero);
		//divider
		categoryListView.separatorStyle = .none;
		categoryListView.allowsMultipleSelection = false;
		//dataSource
		categoryListView.dataSource = presenter?.adapterDataSource;
		categoryListView.delegate = presenter?.delegate;
		//layout view
		view.layout(categoryListView)
			.edges(top: height, left: 0, bottom: 0, right: 0);
		//progress
		progressView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge);
		progressView.color = application?.colorAccent;
		//layout view
		view.layout(progressView)
			.center();
	}
	
	func showProgress() {
		progressView?.startAnimating();
		//hide main view
		categoryListView.isHidden = true;
	}
	
	func hideProgress() {
		progressView?.stopAnimating();
		//show main view
		categoryListView.isHidden = false;
	}
	
	func notifyDataChanged() {
		categoryListView.reloadData();
		//presenter?.delegate?.tableView?(categoryListView, didSelectRowAt: IndexPath(row: 0, section: 0));
		//causes constraint problem for me check for other probabilities
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
		return String(describing: categoryListView.self);
	}
}
