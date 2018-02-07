package
{
	import com.bit101.components.*;
	
	import fl.controls.Button;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	[SWF(width="900", height="500", frameRate="30")]
	public class UnicodeRandeGenerator extends Sprite
	{
		private var urgUtility:URG;
		private var languagesArray:Array;
		private var languagesArLength:uint;
		private var layout:GeneratorLayout;
		private var checkBoxesArr:Array;
		
		private var basicLatinChkbx:CheckBox;
		private var tfRange:TextField;
		private var tfCode:TextField;
		private var timeoutUpdateCode:int;
		public function UnicodeRandeGenerator()
		{
			//0 init
			urgUtility = new URG();
			urgUtility.addEventListener(URG.READY, initialize);
			layout=new GeneratorLayout();
			addChild(layout);
			
		}
		
		private function initialize(e:Event):void {
			languagesArray=urgUtility.languagesArray;
			languagesArLength=languagesArray.length;
			//1 Make checkboxes
			checkBoxesArr=[];
			var initY:Number=30;
			var initX:Number=10;
			var shiftX:Number=initX;
			var shiftY:Number=initY;
			var rangesCont:Sprite=layout.rangesSelectorConatiner;
			for (var i:uint=0; i<languagesArLength; i++) {
				var labelTxt:String=languagesArray[i];
				var checkBox:CheckBox = new CheckBox(null, shiftX, shiftY, labelTxt);
				checkBox.addEventListener(MouseEvent.CLICK, checkStatus);
				checkBox.tag=i
				checkBox.name=labelTxt;
				rangesCont.addChild(checkBox);
				shiftX+=initX+135;
				if ((i+1)%6==0 && i!=0) {
					shiftX=initX;
					shiftY+=18;
				}
				if (labelTxt=="Basic Latin") { 
					basicLatinChkbx=checkBox;
				}
				checkBoxesArr.push(checkBox);
			}
			
			var embeddableTextConatiner:Sprite=layout.embeddableTextConatiner;
			var codeContainer:Sprite=layout.codeContainer;
			//2 Make buttons
		    var buttonClear:PushButton = new PushButton(null, 0, 0, "Clear");
			buttonClear.y =embeddableTextConatiner.height-buttonClear.height-10;
			buttonClear.x=embeddableTextConatiner.width-buttonClear.width-10;
			buttonClear.addEventListener(MouseEvent.CLICK, buttonClearHandler);
			embeddableTextConatiner.addChild(buttonClear);
			//
			var buttonCopy:PushButton = new PushButton(null, 0, 0, "Copy");
			buttonCopy.y=codeContainer.height-buttonCopy.height-10;
			buttonCopy.x=codeContainer.width-buttonCopy.width-10;
			buttonCopy.addEventListener(MouseEvent.CLICK, buttonCopyHandler);
			codeContainer.addChild(buttonCopy);
			
			var rbBtn:SimpleButton=layout.rb;
			rbBtn.addEventListener(MouseEvent.CLICK, rbBtnClick);
			//3 Make textfields
			var textFormatRange:TextFormat=new TextFormat("_serif", 14); 
			var textFormatCode:TextFormat=new TextFormat("_typewriter", 10); 
			
			var availTfWidth:Number=embeddableTextConatiner.width-initX*2;
			var availTfHeight:Number=buttonClear.y-initY-10;
		
			
			tfRange=new TextField();
			tfRange.defaultTextFormat=textFormatRange;
			tfRange.width=availTfWidth;
			tfRange.height=availTfHeight;
			tfRange.x=initX;
			tfRange.y=initY;
			tfRange.type=TextFieldType.INPUT;
			tfRange.multiline=true;
			tfRange.wordWrap=true;
			tfRange.background=true;
			tfRange.addEventListener(TextEvent.TEXT_INPUT, tfRangeInputHandler); 
			tfRange.addEventListener(KeyboardEvent.KEY_UP, tfRangeDeleteHandler); 
			embeddableTextConatiner.addChild(tfRange);
			
			
			availTfHeight=codeContainer.height-initY-5;
			availTfWidth-=(buttonCopy.width+10);
			tfCode=new TextField();
			tfCode.defaultTextFormat=textFormatCode;
			tfCode.width=availTfWidth;
			tfCode.height=availTfHeight;
			tfCode.x=initX;
			tfCode.y=initY;
			tfCode.selectable=true;
			tfCode.multiline=true;
			tfCode.wordWrap=true;
			tfCode.background=true;
			codeContainer.addChild(tfCode);
			
			//4 initialize;
			basicLatinChkbx.selected=true;
			updateRangesSelected ();
		}
		
		private function checkStatus(e:MouseEvent):void {
		//	var chkBx:CheckBox=CheckBox(e.target);
			//trace (chkBx.selected);
			updateRangesSelected ();
		}
		
		private function tfRangeInputHandler(e:TextEvent):void {
			var rangeText:String=tfRange.text;
			trace(rangeText.length);
			if (rangeText.length<4000) updateCodeText(rangeText);
			else {
				clearTimeout(timeoutUpdateCode);
				timeoutUpdateCode=setTimeout(updateCodeText, 600, rangeText);	
			}
		}
		private function tfRangeDeleteHandler(e:KeyboardEvent):void {
			if (e.keyCode==Keyboard.DELETE||e.keyCode==Keyboard.BACKSPACE) {
				var rangeText:String=tfRange.text;
				if (rangeText.length<4000) updateCodeText(rangeText);
				else {
					clearTimeout(timeoutUpdateCode);
					timeoutUpdateCode=setTimeout(updateCodeText, 600, rangeText);	
				}
			}
		}
		
		private function buttonClearHandler(e:MouseEvent):void {
			setRangeText("");
			for (var i:int=0; i<checkBoxesArr.length; i++) {
				var cb:CheckBox=CheckBox(checkBoxesArr[i]);
				cb.selected=false;
			}
		}
		
		private function buttonCopyHandler(e:MouseEvent):void {
			System.setClipboard(tfCode.text);
		}
		
		private function rbBtnClick(e:MouseEvent):void {
			var request:URLRequest = new URLRequest("http://inspiritgames.com");
			try {
				navigateToURL(request, '_blank');
			} catch (e:Error) {
				trace("Error occurred!");
			}
		}
		
		private function updateRangesSelected ():void {
			var tfRangeText:String="";
			for (var i:uint=0; i<checkBoxesArr.length; i++) {
				var checkBox:CheckBox=checkBoxesArr[i];
				if (checkBox.selected==true) {
					var range:String=urgUtility.languagesRangeObj[i];
					var rangeStr:String=urgUtility.languageRangeToString(range);
					tfRangeText+=rangeStr;
				}
			}
			setRangeText(tfRangeText);
		}
		
		private function setRangeText(rangeText:String):void {
			tfRange.text=rangeText;
			updateCodeText(rangeText);
		}
		
		private function updateCodeText(rangeText:String):void {
			var codeText:String='[Embed source="FONT_SOURCE", fontName="FONT_NAME", mimeType="application/x-font-truetype" unicodeRange = "'+urgUtility.getUnicodeRange(rangeText)+'"]';
			tfCode.text=codeText;
		}
	}
} /*
	// js
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
	// endjs
}*/