$(document).ready(function () 
{
	URG.initialize(function () 
  {
		var c = "#ffcc66";
		var d = "#EFEFEF";
		var e = "";
		var f = URG.languages;
		var g = f.length;
		for (var i = 0; i < g; i++) {
			var h = f[i];
			var j = "cb_" + h;
			e += '<div class="cb">';
			e += '<input type="checkbox" name="' + h + '" id="' + j + '"/><label>' + h + '</label>';
			e += "</div>"
		};
		e += "";
		$("div#checkboxes").html(e);
		$("div#checkboxes :checkbox").change(function () 
    {
			var a = "";
			$("div#checkboxes :checkbox:checked").each(function () 
      {
				a += URG.languageRangeToString(URG.getRange($(this).attr("name")));
				$(this).parent().css("background", c)
			});
			$("textarea#source").val(a)
		});
		$("div.cb").hover(function () 
    {
			$(this).css("background", "#CCC")
		},
		function () 
    {
			var a = $(this).find("input:checkbox");
			$(this).css("background", (a.attr("checked")) ? c: d)
		}).click(function (a) 
    {
			var b = $(this).find("input:checkbox");
			if ($(a.target).is(":checkbox")) 
      {
				b.trigger("change");
				return
			};
			b.attr("checked", !(b.attr("checked")));
			b.trigger("change")
		});
		$("input#generate").click(function () 
    {
			$("#output").html('[Embed source="FONT_SOURCE", fontName="FONT_NAME", mimeType="application/x-font-truetype" unicodeRange = "' + URG.getUnicodeRange($("#source").val()) + '"]')
		});
		$("input#clear").click(function () 
    {
			$("div#checkboxes :checkbox").each(function () 
      {
				$(this).attr("checked", false).parent().css("background", d)
			});
			$("textarea#source").val("");
			$("#output").html("")
		});
		$("input[name='Basic Latin']").attr("checked", true).trigger("change")
	})
});
// JavaScript Document
