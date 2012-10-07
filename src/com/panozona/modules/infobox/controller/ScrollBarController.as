/*
Copyright 2012 Marek Standio.

This file is part of SaladoPlayer.

SaladoPlayer is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published
by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.

SaladoPlayer is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty
of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with SaladoPlayer. If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.modules.infobox.controller {
	 
	import com.panozona.modules.infobox.events.WindowEvent;
	import com.panozona.modules.infobox.view.ScrollBarView;
	import com.panozona.player.module.Module;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	public class ScrollBarController {
		
		private var _scrollBarView:ScrollBarView
		private var _module:Module
		
		public function ScrollBarController(scrollBarView:ScrollBarView, module:Module) {
			_scrollBarView = scrollBarView
			_module = module;
			
			var elementsLoader:Loader = new Loader();
			elementsLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, elementsImageLost, false, 0, true);
			elementsLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, elementsImageLoaded, false, 0, true);
			elementsLoader.load(new URLRequest(_scrollBarView.infoBoxData.viewerData.viewer.path));
		}
		
		private function elementsImageLost(e:IOErrorEvent):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, elementsImageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, elementsImageLoaded);
			_module.printError(e.text);
		}
		
		private function elementsImageLoaded(e:Event):void {
			(e.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR, elementsImageLost);
			(e.target as LoaderInfo).removeEventListener(Event.COMPLETE, elementsImageLoaded);
			var gridBitmapData:BitmapData = new BitmapData((e.target as LoaderInfo).width, (e.target as LoaderInfo).height, true, 0);
			gridBitmapData.draw((e.target as LoaderInfo).content);
			
			var cellWidth:Number = Math.ceil((gridBitmapData.width - 1) / 2);
			var cellHeight:Number = Math.ceil((gridBitmapData.height - 1) / 2);
			
			var backgroundTrunkBD:BitmapData = new BitmapData(cellWidth, cellHeight, true, 0);
			backgroundTrunkBD.copyPixels(gridBitmapData, new Rectangle(0, 0, cellWidth, cellHeight), new Point(0, 0), null, null, true);
			var backgroundEndingBD:BitmapData = new BitmapData(cellWidth, cellHeight, true, 0);
			backgroundEndingBD.copyPixels(gridBitmapData, new Rectangle(cellWidth + 1, 0, cellWidth, cellHeight), new Point(0, 0), null, null, true);
			var thumbTrunkBD:BitmapData = new BitmapData(cellWidth, cellHeight, true, 0);
			thumbTrunkBD.copyPixels(gridBitmapData, new Rectangle(0, cellHeight + 1, cellWidth, cellHeight), new Point(0, 0), null, null, true);
			var thumbEndingBD:BitmapData = new BitmapData(cellWidth, cellHeight, true, 0);
			thumbEndingBD.copyPixels(gridBitmapData, new Rectangle(cellWidth + 1, cellHeight + 1, cellWidth, cellHeight), new Point(0, 0), null, null, true);
			
			_scrollBarView.infoBoxData.viewerData.scrollBarData.thumbLength = 100;
			_scrollBarView.build(backgroundTrunkBD, backgroundEndingBD, thumbTrunkBD, thumbEndingBD);
			
			_scrollBarView.infoBoxData.windowData.addEventListener(WindowEvent.CHANGED_CURRENT_SIZE, handleWindowSizeChange, false, 0, true);
			handleWindowSizeChange();
		}
		
		private function handleWindowSizeChange(event:Event = null):void {
			_scrollBarView.draw();
			_scrollBarView.y = 0;
			_scrollBarView.x = _scrollBarView.infoBoxData.windowData.currentSize.width - _scrollBarView.thumb.width;
		}
	}
}