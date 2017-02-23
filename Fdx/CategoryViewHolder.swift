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

class CategoryViewHolder: AbstractViewHolder<Category>,
	LogDelegate {

	static let kIdentifier = "kCategoryViewHolder";

	private let margin: CGFloat = 8;
	
	private var title: UILabel!;
	private var art: UIImageView!;
	
	override var item: Category? {
		didSet {
			if let item = item {
				if let image = item.image {
					art.image = Material.icon(image)?.tint(with: isSelected ? selectedTintColor! : notSelectedTintColor!);
				}
				title.text = item.title;
				title.textColor = isSelected ? selectedTintColor! : notSelectedTintColor!;
			}
		}
	}
	
	var selectedTintColor: UIColor? = Color.pink.base;
	var notSelectedTintColor: UIColor? = Color.white;
	
	var selectedBackgroundColor: UIColor? = Color.grey.darken4;
	var notSelectedBackgroundColor: UIColor? = Color.grey.darken3;
	
	override func prepare() {
		super.prepare();
		art = UIImageView(frame: .zero);
		
		contentView.layout(art)
			.size(CGSize(width: 3 * margin, height: 3 * margin))
			.left(margin)
			.centerVertically();
		
		title = UILabel(frame: .zero);
		title.numberOfLines = 1;
		title.font = RobotoFont.light(with: 14);
		
		contentView.layout(title)
			.horizontally(left: 5 * margin, right: margin)
			.centerVertically();
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated);
		backgroundColor = selected ? selectedBackgroundColor : notSelectedBackgroundColor;
		if let image = art.image {
			art.image = image.tint(with: selected ? selectedTintColor! : notSelectedTintColor!);
		}
		title.textColor = selected ? selectedTintColor! : notSelectedTintColor!;
	}
	
	func isLogEnabled() -> Bool {
		#if DEBUG
			return true;
		#else
			return false;
		#endif
	}
	
	func getClassTag() -> String {
		return String(describing: CategoryViewHolder.self);
	}
}

