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

class MaterialAlertController: UIAlertController {
	
	var positiveHandler: (() -> Void)? = nil;
	var negativeHandler: (() -> Void)? = nil;
	
	private struct Strings {
		static let placeHolder		 = NSLocalizedString("Enter an Element name.", comment: "");
		static let positiveCommand = NSLocalizedString("OK", comment: "");
		static let negativeCommand = NSLocalizedString("CANCEL", comment: "");
	}	
	
	override func viewDidLoad() {
		super.viewDidLoad();
		let textField = ErrorTextField(frame: .zero);
		if let accentColor = application?.colorAccent {
			let icon = UIImageView(frame: .zero);
			icon.image = Material.icon(.ic_person_outline);
		
			textField.leftView = icon;
			textField.leftView?.contentMode = .center;

			textField.leftViewActiveColor = accentColor;
			
			textField.leftViewMode = .always;
			textField.clearButtonMode = .always;
			
			textField.placeholder = Strings.placeHolder;
			textField.placeholderActiveColor = accentColor;
			textField.dividerActiveColor = accentColor;
		}
		
		view.layout(textField)
			.vertically(top: 36, bottom: 48)
			.horizontally(left: 8, right: 8);
		
		let positiveButton = Flat(title: Strings.positiveCommand);
		if let accentColor = application?.colorAccent {
			positiveButton.tintColor = accentColor;
			positiveButton.buttonStyle = .borderless;
		}
		positiveButton.cornerRadius = 0;
		positiveButton.titleLabel?.font = RobotoFont.regular(with: 14);
		positiveButton.addTarget(self, action: #selector(click(_:)), for: .touchUpInside);
		
		view.layout(positiveButton)
			.bottomRight(bottom: 8, right: 8);
		
		view.layoutIfNeeded();
		
		let negativeButton = Flat(title: Strings.negativeCommand);
		if let accentColor = application?.colorAccent {
			negativeButton.tintColor = accentColor;
			negativeButton.buttonStyle = .borderless;
		}
		negativeButton.cornerRadius = 0;
		negativeButton.titleLabel?.font = RobotoFont.regular(with: 14);
		negativeButton.addTarget(self, action: #selector(click(_ :)), for: .touchUpInside);
	
		view.layout(negativeButton)
			.bottomRight(bottom: 8, right: positiveButton.width + 8 * 2);
		
		view.backgroundColor = .white;
		view.depthPreset = .depth3;
	}
	
	@objc func click(_ sender: Any) {
		if let performed = sender as? FlatButton {
			if performed.title == Strings.positiveCommand {
				if let block = positiveHandler {
					block();
				}
			} else if performed.title == Strings.negativeCommand {
				if let block = negativeHandler {
					block();
				}
			}
		}
		dismiss(animated: true, completion: nil);
	}
	
}
