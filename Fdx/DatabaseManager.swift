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

import Core
import SugarRecordCoreData

import RxSwift

class DatabaseManager: NSObject,
	IDatabaseManager, LogDelegate {
		
	private var db: CoreDataDefaultStorage;
	
	override init() {
		let store = CoreDataStore.named("fdxstore");
		let bundle = Bundle(for: DatabaseManager.classForCoder());
		let model = CoreDataObjectModel.merged([bundle]);
		self.db = try! CoreDataDefaultStorage(store: store, model: model);
	}
	
	func all() -> Observable<[Element]> {
		return db.rx.queryAll();
	}

	func remove(_ callback: @escaping (Context) throws -> Element?) -> Observable<Element> {
		return db.rx.delete(callback);
	}
	
	func add(_ callback: @escaping (Context) throws -> Element) -> Observable<Element> {
		return db.rx.create(callback);
	}
	
	func isLogEnabled() -> Bool {
		#if DEBUG
			return true;
		#else
			return false;
		#endif
	}
	
	func getClassTag() -> String {
		return String(describing: DatabaseManager.self);
	}
}

