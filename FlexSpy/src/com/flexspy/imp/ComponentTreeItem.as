/**
 * FlexSpy 1.5
 *
 * <p>Code released under WTFPL [http://sam.zoy.org/wtfpl/]</p>
 * @author Arnaud Pichery [http://coderpeon.ovh.org]
 * @author Frédéric Thomas
 * @author Christopher Pollati
 */
package com.flexspy.imp {
	import flash.display.DisplayObject;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	import mx.core.IChildList;
	import mx.core.IRawChildrenContainer;
	import mx.core.UIComponent;

	public class ComponentTreeItem implements IComponentTreeItem {
		private var _displayObject: DisplayObject;
		private var _label: String;
		private var _children: Array;
		private var _childrenComputed: Boolean;
		private var _propertiesComputed: Boolean;
		private var _icon: Class;
		private var _parent: IComponentTreeItem;

		/**
		 * Creates a new instance of this class.
		 */
		public function ComponentTreeItem(displayObj: DisplayObject, parent: IComponentTreeItem) {
			if (displayObj == null)
				throw new Error("displayOjbect argument cannot be null");

			_displayObject = displayObj;
			_parent = parent;
		}

		/**
		 *  The underlying DisplayObject represented by this item.
		 */
		public function get displayObject(): DisplayObject {
			return _displayObject;
		}

		/**
		 *  The label of the item.
		 */
		public function get label(): String {
			if (!_propertiesComputed) {
				computeProperties();
			}
			return _label;
		}

		/**
		 *  The icon for the item.
		 */
		public function get icon(): Class {
			if (!_propertiesComputed) {
				computeProperties();
			}
			return _icon;
		}

		/**
		 *  The children of this item.
		 */
		public function get children(): Array {
			if (!_childrenComputed) {
				_children = computeChildren();
				_childrenComputed = true;
			}
			return _children;
		}

		/**
		 *  The parent of the item.
		 */
		public function get parent(): IComponentTreeItem {
			return _parent;
		}

		/**
		 * Computes the label & icon for this item from the
		 * underlying DisplayObject
		 */
		private function computeProperties(): void {
			// Compute label
			var className: String = flash.utils.getQualifiedClassName(displayObject);
			_label = Utils.formatDisplayObject(displayObject, className);

			// Figure IconFile from metadata
			try {
				var dt:XML = describeType(displayObject);
				var iconFile:String =  dt.metadata.(attribute("name") == "IconFile").arg.@value;

				if(dt.name) {
					if(iconFile=="") {
						_icon = ComponentIcons.Default;
					} else {
						/*** @todo See if there's a way to actaully access the IconFile without the Component Icons class... */
						_icon = getDefinitionByName("com.flexspy.imp::ComponentIcons_" + iconFile.substring(0,iconFile.lastIndexOf("."))) as Class;
					}
				}
			} catch(error:Error) {
				_icon = ComponentIcons.Default;
			}
		}
		/**
		 * Computes the children of this item.
		 */
		public function computeChildren(): Array {
			var component: UIComponent = displayObject as UIComponent;
			if (component == null)
				return null; // Only UIComponents have children.

			var children: Array = [];

			// Add the "standard" children
			for (var i: int = 0; i < component.numChildren; i++) {
				var child: DisplayObject = component.getChildAt(i);

				// Check that this child is not already present in the collection
				if (child != null && !containsChild(children, child)) {
					children.push(new ComponentTreeItem(child, this));
				}
			}

			// Add the "Chrome" children
			if (component is IRawChildrenContainer) {
				var childList: IChildList = IRawChildrenContainer(component).rawChildren;
				var chromeChildren: Array = [];
				var chromeItem: ComponentTreeChrome = new ComponentTreeChrome(chromeChildren, this);

				// Add the chrome children
				for (var k: int = 0; k < childList.numChildren; k++) {
					var kchild: DisplayObject = childList.getChildAt(k);

					// Check that this child is not already present in the collection
					if (!containsChild(children, kchild) && kchild != null) {
						chromeChildren.push(new ComponentTreeItem(kchild, chromeItem));
					}
				}

				if (chromeChildren.length > 0) {
					children.push(chromeItem);
				}
			}
			return (children.length == 0) ? null : children;
		}

		/**
		 * Indicates whether the specified DisplayObject is present in the given children collection
		 */
		private static function containsChild(children: Array, displayObj: DisplayObject): Boolean {
			for each (var kid: IComponentTreeItem in children) {
				if (kid is ComponentTreeItem && ComponentTreeItem(kid).displayObject == displayObj) {
					return true;
				}
			}
			return false;
		}

		/**
		 * Gets the child component that intersects with the supplied stage coordinate
		 */
		public function getHitComponent(x: Number, y: Number, includeChrome: Boolean): ComponentTreeItem {
			if (_displayObject.visible && _displayObject.hitTestPoint(x, y, true)) {
				for each (var item: IComponentTreeItem in children) {
					if (item is ComponentTreeItem) {
						var result: ComponentTreeItem = ComponentTreeItem(item).getHitComponent(x, y, includeChrome);
						if (result != null) {
							return result;
						}
					} else if (includeChrome && (item is ComponentTreeChrome)) {
						var resultChrome: ComponentTreeItem = ComponentTreeChrome(item).getHitComponent(x, y, includeChrome);
						if (resultChrome != null) {
							return resultChrome;
						}
					}
				}
				// Not inside its children, return this component.
				return this;
			} else {
				return null;
			}
		}

		public function getItemByDisplayObject(displayObject: DisplayObject): IComponentTreeItem {
			if (displayObject === _displayObject) {
				return this;
			}
			var result: IComponentTreeItem;
			for each (var item: IComponentTreeItem in children) {
				result = item.getItemByDisplayObject(displayObject);
				if (result != null) {
					return result;
				}
			}
			// Not found
			return null;
		}
	}
}