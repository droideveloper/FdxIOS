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

import Swinject

class AppComponent: AssemblyType {
	
	func assemble(container: Container) {
		container.register(IDatabaseManager.self, factory: { _ in DatabaseManager() })
			.inObjectScope(.container);
		
		
		container.register(ICategoryListView.self, factory: { _ in CategoryListView() })
			.initCompleted({ (injector, view) in
				if let view = view as? CategoryListView {
					view.presenter = injector.resolve(ICategoryListPresenter.self);
				}
			});
		
		container.register(ICategoryListPresenter.self, factory: { _ in CategoryListPresenter() })
			.initCompleted({ (injector, presenter) in
				if let presenter = presenter as? CategoryListPresenter {
					presenter.view = injector.resolve(ICategoryListView.self);
				}
			});
		
		container.register(ICalculateListPresenter.self, factory: { _ in CalculateListPresenter() })
			.initCompleted({ (injector, presenter) in
				if let presenter = presenter as? CalculateListPresenter {
					presenter.view = injector.resolve(UIViewController.self, name: "ic_search") as? ICalculateListView;
					presenter.dbManager = injector.resolve(IDatabaseManager.self);
				}
			});
		container.register(UIViewController.self, name: "ic_search", factory: { _ in CalculateListView() })
			.initCompleted({ (injector, view) in
				if let view = view as? CalculateListView {
					view.presenter = injector.resolve(ICalculateListPresenter.self);
				}
			});
		
		container.register(IMoleculeListPresenter.self, factory: { _ in MoleculeListPresenter() })
			.initCompleted({ (injector, presenter) in
				if let presenter = presenter as? MoleculeListPresenter {
					presenter.view = injector.resolve(UIViewController.self, name: "ic_map") as? IMoleculeListView;
					presenter.dbManager = injector.resolve(IDatabaseManager.self);
				}
			});
		container.register(UIViewController.self, name: "ic_map", factory: { _ in MoleculeListView() })
			.initCompleted({ (injector, view) in
				if let view = view as? MoleculeListView {
					view.presenter = injector.resolve(IMoleculeListPresenter.self);
				}
			});
		
		container.register(IElementListPresenter.self, factory: { _ in ElementListPresenter() })
			.initCompleted({ (injector, presenter) in
				if let presenter = presenter as? ElementListPresenter {
					presenter.view = injector.resolve(UIViewController.self, name: "ic_image") as? IElementListView;
					presenter.dbManager = injector.resolve(IDatabaseManager.self);
				}
			});
		container.register(UIViewController.self, name: "ic_image", factory: { _ in ElementListView() })
			.initCompleted({ (injector, view) in
				if let view = view as? ElementListView {
					view.presenter = injector.resolve(IElementListPresenter.self);
				}
			});
	}
	
	func loaded(resolver: ResolverType) { }
}
