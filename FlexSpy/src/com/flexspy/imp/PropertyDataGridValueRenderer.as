/**
 * FlexSpy 1.5
 *
 * <p>Code released under WTFPL [http://sam.zoy.org/wtfpl/]</p>
 * @author Arnaud Pichery [http://coderpeon.ovh.org]
 * @author Frédéric Thomas
 * @author Christopher Pollati
 */
package com.flexspy.imp {
	import com.flexspy.FlexSpy;
	import com.flexspy.event.FlexSpyEvent;

	import flash.events.MouseEvent;

	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.core.ScrollPolicy;
	import com.flexspy.FlexSpy_Internal;

	public class PropertyDataGridValueRenderer extends Canvas {

		protected var valueLabel: Label;
		protected var editButton: Image;

		/**
		 * Constructor
		 */
		public function PropertyDataGridValueRenderer() {
			this.horizontalScrollPolicy = ScrollPolicy.OFF;
			this.verticalScrollPolicy = ScrollPolicy.OFF;
		}

		protected function onClickEditButton(event: MouseEvent): void {
			IPropertyEditor(owner.parent).editSelectedCell();
		}

		public override function set data(value:Object):void {
			super.data = value;

			if (value != null) {
				var item: PropertyEditorItem = PropertyEditorItem(value);
				valueLabel.text = item.displayValue;
				editButton.visible = item.editable;
			} else {
				valueLabel.text = "";
				editButton.visible = false;
			}
		}


		private function onClickLabel( event : MouseEvent ) : void  {
			var flexSpyEvent : FlexSpyEvent = new FlexSpyEvent(FlexSpyEvent.PROPERTY_SELECTED, event, null,data.value, data.displayName);
			FlexSpy.FlexSpy_Internal::dispatchEvent(flexSpyEvent);
		}

		protected override function createChildren(): void {
			super.createChildren();
			if (valueLabel == null) {
				valueLabel = new Label();
				valueLabel.minWidth = 0;
				valueLabel.setStyle("left", 2);
				valueLabel.setStyle("top", 0);
				valueLabel.setStyle("right", 15);
				valueLabel.setStyle("bottom", 0);
				this.addChild(valueLabel);
				valueLabel.addEventListener(MouseEvent.CLICK, onClickLabel);
				valueLabel.addEventListener(MouseEvent.DOUBLE_CLICK, onClickEditButton);
			}

			if (editButton == null) {
				editButton = new Image();
				editButton.source = Icons.EDIT;
				editButton.width = 9;
				editButton.height = 9;
				editButton.addEventListener(MouseEvent.CLICK, onClickEditButton);
				editButton.setStyle("top", 2);
				editButton.setStyle("right", 4);
				this.addChild(editButton);
			}
		}
	}
}