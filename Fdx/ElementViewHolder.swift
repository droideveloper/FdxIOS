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

class ElementViewHolder: AbstractViewHolder<Element>,
	LogDelegate {
	
	static let kIdentifier = "kElementViewHolder";
	
	private let margin: CGFloat = 8;
	private var title: UILabel!;
	
	override var item: Element? {
		didSet {
			if let item = item {
				title.text = item.name;
			}
		}
	}
	
	override func prepare() {
		super.prepare();
		title = UILabel(frame: .zero);
		title.font = RobotoFont.light(with: 14);
		title.textColor = UIColor.rgb(0x333333);
		
		contentView.layout(title)
			.horizontally(left: margin, right: margin)
			.centerVertically()
		
		pulseColor = .clear;
		pulseOpacity = 0;
		
		contentView.backgroundColor = .white;
	}
	
	func isLogEnabled() -> Bool {
		#if DEBUG
			return true;
		#else
			return false;
		#endif
	}
	
	func getClassTag() -> String {
		return String(describing: ElementViewHolder.self);
	}
}
