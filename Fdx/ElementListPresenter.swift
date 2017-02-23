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

import CoreData
import SugarRecordCoreData

import Core
import RxSwift

import Material

class ElementListPresenter: AbstractPresenter<IElementListView>,
	IElementListPresenter, LogDelegate, UITableViewDelegate {
	
	private let recycler = DisposeBag();
	private var adapter: ElementAdapter?;
	
	var dbManager: IDatabaseManager?;
	
	var dataSource: UITableViewDataSource? {
		get {
			return adapter;
		}
	}
	
	var delegate: UITableViewDelegate? {
		get {
			return self;
		}
	}
	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		return [UITableViewRowAction(style: .destructive, title: NSLocalizedString("Remove", comment: "Remove item action for swipe gesture"), handler: deleted)];
	}
	
	private func deleted(_ action: UITableViewRowAction, _ index: IndexPath) {
		dbManager?.remove({ [weak weakSelf = self] (ctx) -> Element? in
			return weakSelf?.adapter?.dataSource?.get(index: index.row);
		}).subscribeOn(ConcurrentMainScheduler.instance)
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak weakSelf = self] (item) in
				weakSelf?.adapter?.dataSource?.remove(at: index.row);
				weakSelf?.view?.notifyItemsRemoved([index]);
			}, onError: log)
			.addDisposableTo(recycler);
	}
	
	func click(_ sender: Any) {
		if sender is IconButton {
			BusManager.post(event: MenuActionEvent(isOpen: true));
		} else {
			let dialog = UIAlertController(title: NSLocalizedString("Create Element", comment: "Create element title for dialog."), message: nil, preferredStyle: .alert);
			dialog.addTextField(configurationHandler: { (textField) in
				textField.placeholder = NSLocalizedString("Enter an Element name.", comment: "Element name placeholder.");
			});
			let btnOk = UIAlertAction(title: NSLocalizedString("OK", comment: "Ok text"), style: .default, handler: { [weak weakSelf = self, dialog = dialog] _ in
				let str = dialog.textFields?.first?.text;
				if let str = str?.trimmed {
					weakSelf?.createNewElement(str);
				}
			});
			let btnCancel = UIAlertAction(title: NSLocalizedString("CANCEL", comment: "Cancel text"), style: .default, handler: nil);
			dialog.addAction(btnOk);
			dialog.addAction(btnCancel);
			view?.showDialog(dialog);
		}
	}
	
	func viewDidLoad() {
		adapter = ElementAdapter();
		view?.prepareView();
		view?.prepareToolbar();
		
		view?.showProgress();
		loadDataIfNeeded();
	}
	
	func viewWillDisappear(_ animated: Bool) { }
	func viewWillAppear(_ animated: Bool) {	}
	func didReceiveMemoryWarning() { }
	
	private func loadDataIfNeeded() {
		dbManager?.all()
			.observeOn(MainScheduler.instance)
			.subscribeOn(ConcurrentMainScheduler.instance)
			.subscribe(onNext: success, onError: log, onCompleted: completed)
			.addDisposableTo(recycler);
	}
	
	private func addContexBlock(_ str: String) -> ((Context) throws -> Element) {
		return { (ctx) in
			let item: Element = try ctx.create();
			item.name = str;
			return item;
		};
	}
	
	private func createNewElement(_ str: String) {
		dbManager?.add(addContexBlock(str))
			.observeOn(MainScheduler.instance)
			.subscribeOn(ConcurrentMainScheduler.instance)
			.subscribe(onNext: { [weak weakSelf = self] (item) in
				weakSelf?.adapter?.dataSource?.add(item: item);
				if let index = weakSelf?.adapter?.dataSource?.size() {
					weakSelf?.view?.notifyItemsInserted([IndexPath(row: index - 1, section: 0)]);
				}
			}, onError: log)
			.addDisposableTo(recycler);
	}
	
	private func success(_ data: [Element]) {
		adapter?.dataSource = data;
		view?.notifyDataChanged();
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
		return String(describing: ElementListPresenter.self);
	}
}
