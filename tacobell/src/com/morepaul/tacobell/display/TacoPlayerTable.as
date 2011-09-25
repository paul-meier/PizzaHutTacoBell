/*
 *  Copyright (c) 2011 Paul Meier
 *  
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *  
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *  
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 */

package com.morepaul.tacobell.display
{

	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import com.morepaul.tacobell.data.TacoMatch;
	import com.morepaul.tacobell.data.TacoPlayer;

	public class TacoPlayerTable extends Sprite
	{
		private static const Y_INCREMENT : uint = 60;
		private static const Y_START : uint = 60;

		private var m_media : TacoMediaManager;
		private var m_prettyFormat : TextFormat;
		private var m_background : Shape;

		public function TacoPlayerTable( x : uint, y : uint, width : uint, height  : uint ):void
		{ 
			super(); 
			
			this.x = x;
			this.y = y;
			this.height = height;
			this.width = width;

			var m_background : Shape = new Shape();
			this.addChild(m_background);

			m_prettyFormat = new TextFormat();
			m_prettyFormat.align = TextFormatAlign.CENTER;
			m_prettyFormat.bold = true;
			m_prettyFormat.color = 0x6BF8FF;
			m_prettyFormat.font = "Arial";
			m_prettyFormat.size = 16;
		}


		public function set media( m : TacoMediaManager) : void { m_media = m; }


		/**
		 * The main functionality, displays a table presenting all the 
		 * player-specific data of a match. Sc2Gears only really gives us
		 * apm, race, and usually league.  Maybe we can include portraits?
		 */
		public function display( players : Array ):void
		{
			drawBackground();

			var numCols : uint = players.length;

			var colWidth : uint = (this.width / numCols);

			var rightColBoundary : uint = colWidth;
			var leftColBoundary : uint = 0;

			for (var i:int = 0; i < players.length; ++i)
			{
				var yValue : uint = Y_START;

				var thisPlayer : TacoPlayer = players[i];

				// Define the boundaries of the column...
				var colIncrement : uint = (rightColBoundary - leftColBoundary) / 4;
				var xCol1 : uint = leftColBoundary + colIncrement;
				var xCol2 : uint = leftColBoundary + (2 * colIncrement);
				var xCol3 : uint = leftColBoundary + (3 * colIncrement);

				var nameStr   : String = thisPlayer.name;
				var leagueStr : String = thisPlayer.league;
				var raceStr : String = thisPlayer.race;
				var rank : uint = thisPlayer.rank;

				var raceImg : Bitmap = m_media.race(raceStr);
				var nameTF : TextField = createPrettyTextField(nameStr);
				var leagueImg : Bitmap = m_media.league(leagueStr, rank);

				raceImg.width = 50;
				raceImg.height = 50;

				leagueImg.width = 50;
				leagueImg.height = 50;

				// place the name row...
				raceImg.x   = xCol1 - (raceImg.width / 2);
				nameTF.x    = xCol2 - (nameTF.width / 2);
				leagueImg.x = xCol3 - (raceImg.width / 2 );

				raceImg.y   = yValue;
				nameTF.y    = yValue;
				leagueImg.y = yValue;

				addChild(raceImg);
				addChild(nameTF);
				addChild(leagueImg);

				yValue += Y_INCREMENT;

				// Place the APM -- 
				var apmStr : String = thisPlayer.apm.toString();

				var apmTF : TextField = createPrettyTextField(apmStr);

				apmTF.x = xCol2 - (apmTF.width / 2);
				apmTF.y = yValue;

				addChild(apmTF);

				leftColBoundary += colWidth;
				rightColBoundary += colWidth;
			}
		}


		private function drawBackground():void
		{
//			m_background.graphics.lineStyle();
//			m_background.graphics.beginFill(0x4036FF);
//			m_background.graphics.drawRect(0,0, this.width, this.height);
//			m_background.graphics.endFill();
		}


		/** 
		 * Makes a new TextField the way we want it! Initializes styles, sets contents, etc.
		 */
		private function createPrettyTextField( contents : String ):TextField
		{
			var tf : TextField = new TextField();

			tf.text = contents;
			tf.setTextFormat(m_prettyFormat);

			tf.antiAliasType = AntiAliasType.ADVANCED;

			return tf;
		}
	}
}
