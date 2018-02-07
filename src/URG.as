package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	

	public class URG extends Sprite
	{
		public static const READY:String="ready"
		private var xmlPathString:String = "flash-unicode-table.xml";
		internal var languagesArray:Array = []; // m
		internal var languagesRangeObj:Array = []; // n
		
		public function URG()
		{
			var loader:URLLoader = new URLLoader(); 
			var url:URLRequest = new URLRequest(xmlPathString); 
			loader.addEventListener(Event.COMPLETE, onXMLLoad);
			XML.ignoreWhitespace=true;
			loader.load(url);

		}
				
		private function onXMLLoad(e:Event):void {
			parseLanguageXML(new XML(e.target.data));
		}
		
		private function parseLanguageXML (languageXML:XML):void 
		{
			var e:String = "";
			for each (var rangeData:XML in languageXML.children()) {
				var b:String =rangeData.lang;
				var c:String = rangeData.range;
				if (b=="Chinese (All)") b+=" (May be slow!)";
				languagesArray.push(b);
				languagesRangeObj.push(c);
			}
		 dispatchEvent(new Event(URG.READY));
		};
		
		public function languageRangeToString (languageRange:String):String 
		{
			var d:String = "";
			var e:RegExp = /U\+(\w+)(\-(\w+))?\,?/g;
			var languageRangeString:String=languageRange.replace(e, replaceFunction);
			//trace (languageRangeString);
			return languageRangeString;
		};
		
		private function replaceFunction (...arguments):String {
			var d:String="";	
			var a:uint = parseInt(arguments[1], 16);
			// fix for 0000 unicode symbol
			if (a==0) {
				a=1;
			}
			///
			if (arguments[3]!="") {
				var b:uint = parseInt(arguments[3], 16);
			    for (var i:int = a; i <= b; i++) {
					d += String.fromCharCode(i);
				}
			}
			else {
				d +=String.fromCharCode(a);
			}
			return d;
		}
		
		public function getUnicodeRange (c:String):String {
			var d:String = "";
			
			//var o:Array = [];
			var f:int = c.length;
			var e:Vector.<int> = new Vector.<int>();
			if (f > 0) {
				var g:uint;
				for (var i:uint = 0; i < f; i++) {
					g = c.charCodeAt(i);
					//o[g] = g
					e.push(g);
				};

				e=createUniqueCopy(e);
				e.sort(Array.NUMERIC);
				//trace (e.length);
				var codeString:String;
				var length:int = e.length;
				var next_i:int=0;
				var prev_i:int=0;
				
				for (i=0; i<length; i++) {
					next_i=i+1;
					if(i==length-1) {
					   if (i==0 || e[i]!=e[i-1]+1) d+="U+";
					   codeString=e[i].toString(16).toUpperCase();
					   codeString.length<4?codeString=addLeadingZero(codeString,4):null;
					   d+=codeString;
					   break;
					}
					else if (e[i]==e[next_i]-1) {// последовательность
						 if (i==0 || e[i]!=e[i-1]+1) { // начало последовательности
						    codeString=e[i].toString(16).toUpperCase();
							codeString.length<4?codeString=addLeadingZero(codeString,4):null;
							d+="U+"+codeString+"-";
							continue;
						 }
						 continue;
					}
					else if (e[i]!=e[next_i]-1) {//одиночный элемент
						if (i==0 || e[i]!=e[i-1]+1) d+="U+";
						codeString=e[i].toString(16).toUpperCase();
						codeString.length<4?codeString=addLeadingZero(codeString,4):null;
						d+=codeString+",";
						continue;
					}
				}
			}
			return d
		}
		
		public function createUniqueCopy(a:Vector.<int>):Vector.<int>
		{
			var newArray:Vector.<int> = new Vector.<int>();
			
			var len:Number = a.length;
			var item:int;
			
			for (var i:uint = 0; i < len; ++i)
			{
				item = a[i];

				if(newArray.indexOf(item) != -1)
				{
					continue;
				}
				newArray.push(item);
			}
			return newArray;
		}
		
		
		private function addLeadingZero(a:String, b:uint):String
		{
			while (a.length < b) {
				a = "0" + a
			};
			return a
		};
		
		internal function getRange (a:String):String 
		{
			return languagesRangeObj[a];
		}
		
	}
}
/*
	// js
	var URG = function () 
	{

		
		
		languageRangeToString = function (c) 
		{
			var d = "";
			var e = /U\+(\w+)(\-U\+(\w+))?/g;
			c.replace(e, function () {
				if (arguments[2]) {
					var a = parseInt(arguments[1], 16);
					var b = parseInt(arguments[3], 16);
					for (var i = a; i <= b; i++) {
						d += String.fromCharCode(i)
					}
				}
			});
			return d
		};
		
		getUnicodeRange = function (c) 
		{
			var d = "";
			var e = [];
			var o = {};
			var f = c.length;
			if (f > 0) {
				var g;
				for (var i = 0; i < f; i++) {
					g = c.charCodeAt(i);
					o[g] = g
				};
				for (var h in o) {
					e[e.length] = o[h]
				};
				e.sort(function (a, b) {
					return a - b
				});
				var j = 0;
				f = e.length;
				for (i = 1; i < f; i++) {
					if (e[i] != e[i - 1] + 1) {
						if (i - j == 1) d += "U+" + addLeadingZero(e[j].toString(16), 4);
						else d += "U+" + addLeadingZero([j].toString(16), 4) + "-" + "U+" + addLeadingZero(e[i - 1].toString(16), 4);
						d += ",";
						j = i
					}
				};
				if (j == f - 1) d += "U+" + addLeadingZero(e[j].toString(16), 4);
				else d += "U+" + addLeadingZero(e[j].toString(16), 4) + "-" + "U+" + addLeadingZero(e[f - 1].toString(16), 4)
			}
			return d
		};
		
		addLeadingZero = function (a, b) 
		{
			while (a.length < b) {
				a = "0" + a
			};
			return a
		};
		
		return 
		{
			languages: m,
			languageRange: n,
			initialize: function (a) 
			{
				p = a;
				k = $.get(l, parseLanguageXML, "xml")
			},
			getRange: function (a) 
			{
				return n[a]
			},
			getUnicodeRange: getUnicodeRange,
			languageRangeToString: languageRangeToString
		}
	} 
	// end js
*/	
