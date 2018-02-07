var URG = function () 
{
	var k;
	var l = "./flash-unicode-table.xml";
	var m = [];
	var n = {};
	var p;
	
  parseLanguageXML = function (d) 
  {
		var e = "";
		$(d).find("language-range").each(function () {
			var a = $(this);
			var b = a.find("lang").text();
			var c = a.find("range").text();
			m[m.length] = b;
			n[b] = c
		});
		if (p) p()
	};
	
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
();