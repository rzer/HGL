package hgl.ui.collections;

import h2d.Object;
import hgl.ui.core.Component;
import hgl.common.time.Ticker;

/**
 * ...
 * @author rzer
 */
class List extends Component {
	
	private var items:Array<Component> = [];
	
	private var isVertical:Bool;
	private var itemsPerLine:Int;
	private var xGap:Int;
	private var yGap:Int;

	public function new(isVertical:Bool = true, itemsPerLine:Int = 1, xGap:Int = 10, yGap:Int = 10, parent:Object = null) {
		super(parent, 100, 100);
		this.xGap = xGap;
		this.yGap = yGap;
		this.itemsPerLine = itemsPerLine;
		this.isVertical = isVertical;
	}
	
	public function addItem(item:Component):Void {
		
		var anIndex:Int = items.indexOf(item);
		if (anIndex != -1) return;
		
		items.push(item);
		addChild(item);
		
		Ticker.onFrame.once(moveItems);
	}
			
	public function removeItem(item:Component):Void {
		
		var anIndex:Int = items.indexOf(item);
		if (anIndex == -1) return;
		
		items.splice(anIndex, 1);
		removeChild(item);
		
		Ticker.onFrame.once(moveItems);
	}
	
	private function moveItems():Void {
		isVertical ? arrangeCols() : arrangeRows();
	}
	
	private function arrangeCols():Void {
		
		var w:Int = 0;
		
		var dx:Int = xGap;
		var dy:Int = yGap;
		
		var col:Int = 0;
		
		var rowHeight:Int = 0;
		
		for (i in 0 ... items.length){
			
			var item:Component = items[i];
			item.x = dx; item.y = dy;
			
			dx += item.w;
			if (w < dx ) w = dx;
			
			dx += xGap;
			rowHeight = item.h > rowHeight ? item.h : rowHeight;
			
			col++;
			
			if (col >= itemsPerLine){
				dx = xGap;
				dy += rowHeight + yGap;
				rowHeight = 0;
				col = 0;
			}
			
			
		}
		
		w += xGap;
		
		var h:Int = dy;
		if (rowHeight > 0) h += rowHeight + yGap;	
		
		trace(rowHeight, yGap, dy);
		resize(w, h);
	}
	
	private function arrangeRows():Void {
	
		var h:Int = 0;
		
		var dx:Int = xGap;
		var dy:Int = yGap;
		
		var row:Int = 0;
		
		var colWidth:Int = 0;
		
		for (i in 0 ... items.length){
			
			var item:Component = items[i];
			item.x = dx;
			item.y = dy;
			
			dy += item.h;
			if (h < dy ) h = dy;
			
			dy += yGap;
			
			colWidth = item.w > colWidth ? item.w : colWidth;
			
			row++;
			
			if (row >= itemsPerLine){
				dy = yGap;
				dx += colWidth + xGap;
				colWidth = 0;
				row = 0;
			}
			
			
		}
		
		h += yGap;
		
		var w:Int = dx;
		if (colWidth > 0) w += colWidth + xGap;	
		
		resize(w, h);
	}
	
	override public function resize(w:Int, h:Int):Void {
		trace("resize list", w, h);
		super.resize(w, h);
	}
		
	
}