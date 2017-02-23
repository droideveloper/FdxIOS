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
 
import Core

import RxSwift

class CategoryListPresenter: AbstractPresenter<ICategoryListView>,
	ICategoryListPresenter, LogDelegate, UITableViewDelegate {
	
	var adapterDataSource: UITableViewDataSource? {
		get {
			return adapter;
		}
	}
	
	var delegate: UITableViewDelegate? {
		get {
			return self;
		}
	}
	
	private var selectedCategory: Category?;
	private var subscription: Disposable?;
	private var adapter:  CategoryAdapter?;
	
	func viewDidLoad() {
		adapter = CategoryAdapter();
		//start prepare view
		view?.prepareView();
		//load data
		loadDataIfNeeded();
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectCategoryAt(indexPath.row);
		selectViewHolder(tableView.cellForRow(at: indexPath));
	}
	
	func viewWillDisappear(_ animated: Bool) {
		if let subscription = subscription {
			subscription.dispose();
		}
	}
	
	func viewWillAppear(_ animated: Bool) { }
	func didReceiveMemoryWarning() { }
	
	//this select thing can be way better
	private func selectCategoryAt(_ index: Int) {
		let category = adapter?.dataSource?.get(index: index);
		if category != selectedCategory {
			if let injector = view?.application?.injector?.resolver {
				if let named = category?.image {
					if let viewController = injector.resolve(UIViewController.self, name: "\(named)") {
						viewController.title = category?.title;
						selectedCategory = category;
						BusManager.post(event: ContentActionEvent(viewController));
						return; // we do not try to close over and over again.
					}
				}
			}
		}
		BusManager.post(event: MenuActionEvent(isOpen: false));
	}
	
	private func selectViewHolder(_ viewHolder: UITableViewCell?) {
		if let viewHolder = viewHolder as? CategoryViewHolder {
			viewHolder.setSelected(true, animated: false);
		}
	}
	
	private func loadDataIfNeeded() {
		view?.showProgress();
		//start
		subscription = Observable.just(true)
			.flatMap({ x -> Observable<[Category]> in
				var data = [Category]();
				//change the icon sets
				data.add(item: Category(title: NSLocalizedString("Formula", comment: "Formula Category Name"), image: IconSet.ic_search));
				data.add(item: Category(title: NSLocalizedString("Molecule", comment: "Molecule Category Name"), image: IconSet.ic_map));
				data.add(item: Category(title: NSLocalizedString("Element", comment: "Element Category Name"), image: IconSet.ic_image));
				return Observable.just(data);
			})
			.subscribeOn(ConcurrentMainScheduler.instance)
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: success, onError: error, onCompleted: completed);
	}
	
	private func success(_ data: [Category]) {
		adapter?.dataSource = data;
		view?.notifyDataChanged();
	}
	
	private func error(_ error: Error) {
		log(error: error);
	}
	
	private func completed() {
		view?.hideProgress();
	}
	
	func isLogEnabled() -> Bool {
		#if DEBUG
			return true;
		#else
			return false;
		#endif
	}
	
	func getClassTag() -> String {
		return String(describing: CategoryListPresenter.self);
	}
}
