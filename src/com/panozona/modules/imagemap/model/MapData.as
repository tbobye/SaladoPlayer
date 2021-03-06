﻿/*
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
package com.panozona.modules.imagemap.model {
	
	import com.panozona.modules.imagemap.events.MapEvent;
	import com.panozona.modules.imagemap.model.structure.ExtraWaypoint;
	import com.panozona.modules.imagemap.model.structure.Map;
	import com.panozona.modules.imagemap.model.structure.Maps;
	import com.panozona.modules.imagemap.model.structure.Waypoints;
	import com.panozona.player.module.data.property.Size;
	import flash.events.EventDispatcher;
	
	public class MapData extends EventDispatcher {
		
		public const maps:Maps = new Maps();
		
		private var _currentMapId:String
		private var _size:Size;
		private var _radarFirst:Boolean;
		private var _currentExtraWaypointId:String
		
		public function MapData() {
			_currentMapId = null;
			_size = null;
			_radarFirst = false
		}
		
		public function getMapById(mapId:String):Map {
			for each(var map:Map in maps.getChildrenOfGivenClass(Map)) {
				if (map.id == mapId) return map;
			}
			return null;
		}
		
		public function get currentMapId():String {return _currentMapId;}
		public function set currentMapId(value:String):void {
			if (value == null || value == _currentMapId) return;
			_currentMapId = value;
			dispatchEvent(new MapEvent(MapEvent.CHANGED_CURRENT_MAP_ID));
		}
		
		public function get size():Size {return _size;}
		public function set size(value:Size):void {
			_size = value;
			dispatchEvent(new MapEvent(MapEvent.CHANGED_SIZE));
		}
		
		public function get radarFirst():Boolean {return _radarFirst;}
		public function set radarFirst(value:Boolean):void {
			_radarFirst = value;
			dispatchEvent(new MapEvent(MapEvent.CHANGED_RADAR_FIRST));
		}
		
		public function getExtraWaypointById(extraWaypointId:String):ExtraWaypoint {
			for each(var map:Map in maps.getChildrenOfGivenClass(Map)) {
				for each(var waypoints:Waypoints in map.getChildrenOfGivenClass(Waypoints)) {
					for each(var extraWaypoint:ExtraWaypoint in waypoints.getChildrenOfGivenClass(ExtraWaypoint)) {
						if (extraWaypoint.id == extraWaypointId) return extraWaypoint;
					}
				}
			}
			return null;
		}
		
		public function get currentExtraWaypointId():String {return _currentExtraWaypointId;}
		public function set currentExtraWaypointId(value:String):void {
			if (value == null || value == _currentExtraWaypointId) return;
			_currentExtraWaypointId = value;
			dispatchEvent(new MapEvent(MapEvent.CHANGED_CURRENT_EXTRAWAYPOINT_ID));
		}
	}
}