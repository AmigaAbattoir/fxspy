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

	public interface IComponentTreeItem {
		/**
		 *  The label of the item.
		 */
		function get label(): String;

		/**
		 *  The icon for the item.
		 */
		function get icon(): Class;

		/**
		 *  The children of this item.
		 */
		[ArrayElementType("com.flexspy.impl.IComponentTreeItem")]
		function get children(): Array;

		/**
		 *  The parent of the item.
		 */
		function get parent(): IComponentTreeItem;

		/**
		 * Gets the child component that intersects with the supplied stage coordinate
		 */
		function getHitComponent(x: Number, y: Number, includeChrome: Boolean): ComponentTreeItem;

		function getItemByDisplayObject(displayObject: DisplayObject): IComponentTreeItem;
	}
}
