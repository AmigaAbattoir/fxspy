/**
 * FlexSpy 1.5
 *
 * <p>Code released under WTFPL [http://sam.zoy.org/wtfpl/]</p>
 * @author Arnaud Pichery [http://coderpeon.ovh.org]
 * @author Frédéric Thomas
 * @author Christopher Pollati
 */
package com.flexspy.imp {
	public interface IPropertyEditor {
		/**
		 * Starts the edition of the currently selected cell.
		 */
		function editSelectedCell(): void;

		/**
		 * Changes the value of the specified property
		 *
		 * @param name Name of the property to change
		 * @param uri Qualifier of the name of the property (optional)
		 * @param value New value of the property
		 */
		function changeItemValue(name: String, uri: String, value: *): void;
	}
}