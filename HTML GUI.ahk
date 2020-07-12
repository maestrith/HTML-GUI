#SingleInstance,Force
global Master,SeparateData:=[],SeparateColumns:=[] ;to make sure it works everywhere!
;~ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;~ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   WHEN GETTING ROW/COLUMN STUFF    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;~ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   TAKE THE TOP/LEFT INTO ACCOUNT   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;~ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!! IF THE TOP IS > THAN THE LAST TOP  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;~ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!               ROW++                !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;~ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Master("MyWin")
Displays:={1:"Main",2:"Second"}
Controls:=["Foo1","Foo2"]
CurrentDisplay:=1
Master.Backup:=[]
if(1){
	M2:=New MasterGUI(2,"LOL",{Background:"Black",Color:"Pink"})
	M2.Reset("Nice<Button Function='Other'>Other Button</Button>")
	M2.Show(20,,200,200)
	M2.MinSize(100,100)
}
Other(){
	Master.m("Nice")
}
LOL(){
	Master.m("LOL!")
}
Nice(){
	Master.m("Nice!")
}
Main()
Search(){
	global
	Value:=Master.QuerySelector("Input").Value
	Letters:=[]
	CV:=Master.QuerySelector("Input[Type='Checkbox']").Checked
	for a,b in StrSplit(Value)
		Letters[b]:=(Letters[b]?Letters[b]+1:1)
	DD:=Displays[CurrentDisplay]
	for a,b in Master.Columns{
		if(!Master.Backup[a])
			Master.Backup[a]:=SeparateData[DD,a]
		Found:=[],Search:=[],Checked:=[]
		for c,d in b{
			if(d.Type!="Checkbox")
				Search.Push(d.ID)
			else
				Checked:=d.ID
		}
		for c,d in Master.Backup[a]{
			Index:=A_Index
			for e,f in Search{
				for g,h in Letters{
					Find:=d[f]
					RegExReplace(Find,"i)"(g),,Count)
					if(Count<h){
						Exist:=0
						Break
					}
					Exist:=1
				}
				if(Exist||!Value){
					if((CV&&d[Checked])||(!CV))
						Found.Push(d)
					Exist:=0
					Break,1
				}
			}
		}Master.BuildBody(Found,a,1)
	}
}
Main(){
	Master.MinSize(688,100)
	SetBatchLines,-1
	Master.Reset()
	Master.AutoCommit()
	Controls:=["Foo1","Foo2"]
	Master.Hotkeys({q:"Nice"})
	Master.CreateElement("Span",,{ID:"Header"},,"Press F1 to clear the data, F2 to populate the data, F3 for Random Data, and Shift+F1")
	Master.CreateElement("Input",,{Function:"Search",AutoCommit:1})
	Master.CreateElement("Input",,{Type:"Checkbox",Function:"Search"})
	Div:=Master.CreateElement("Div",,,{Display:"Inline-Block",Float:"Left",Width:"100%"})
	Master.CreateElement("Listview",Div,,{Float:"Left",Width:"50%",Height:"calc(100% - 21px)"},"Foo1")
	Master.CreateElement("Listview",Div,,{Float:"Left",Width:"50%",Height:"calc(100% - 21px)"},"Foo2")
	Columns:=[{ID:"ID",Name:"Identification",Type:"Text"},{ID:"Check",Name:"Random Check",Type:"Checkbox"},{ID:"Text2",Name:"Text Info 2",Type:"Input"}]
	if(!SeparateData.Main.Foo1){
		Data:=[]
		Loop,20
			Data.Push({ID:A_Index,RowID:A_Index,Check:"0",Text2:"Text Info "(A_Index)})
		SeparateData["Main","Foo1"]:=Data
		SeparateData["Main","Foo2"]:=Data
	}
	Master.BuildLV("Foo1",Columns,SeparateData.Main.Foo1)
	Master.BuildLV("Foo2",Columns,SeparateData.Main.Foo2)
	Master.AddCSS(".Outer#Foo1 Span.Header#ID","{Color:Red}")
	Master.AddCSS(".Outer#Foo2 Span.Header#ID","{Color:#FF00FF}")
	Master.AddCSS("Span.Header#Text2","{Color:Yellow}")
	Master.Tab()
	Master.CreateElement("Style").InnerHTML:=Foo
	Master.Show(,,800,500)
	Master.OddCSS("#555")
	Master.EvenCSS("#333")
	Master.EvenCSS("#880000","Foo2")
	Master.Highlight:="#aaa"
	SeparateData.Main:=Master.Data
	SeparateColumns.Main:=Columns
	return
}
Second(){
	Master.MinSize(300,140)
	HTML:="<Div Style='Width:calc(100%-4px);Border:2px Solid Pink'>Nice<Button Function='LOL'>Neat</Button><br/><br/><br/>Yay!</Div>"
	Master.Reset(HTML)
	Master.AutoCommit(1)
	Master.CreateElement("Listview",,,{Height:"calc(100% - 80px)"},"Foo3")
	Columns:=[{ID:"ID",Name:"Identification",Type:"Text"},{ID:"Check",Name:"Random Check",Type:"Checkbox"},{ID:"Text2",Name:"Text Info 2",Type:"Input"}]
	SeparateColumns.Second:=Columns
	if(!Data:=SeparateData.Second.Foo3){
		Data:=[]
		Loop,20
			Data.Push({ID:A_Index,Check:1,Text2:"Nice "(A_Index),RowID:A_Index})
	}
	Master.Changed:="Purple"
	Master.BuildLV("Foo3",Columns,Data)
	Master.Show(,,1300,500)
	Master.Highlight:="Orange"
	Master.EvenCSS("#333")
	Master.OddCSS("Pink")
	Master.Tab()
	SeparateData.Second:=Master.Data
	return
}
+F1::
Switch()
return
+F2::
HTML()
return
F1::
for a,b in Master.Columns{
	Master.LVDelete(a)
}
return
F2::
for a,b in Master.Columns{
	DD:=Displays[CurrentDisplay]
	Master.BuildBody(SeparateData[DD,a],a,1)
}
return
F3::
Master.Backup:=[]
Count:=200
Master.ChangedObj:=[]
for a,b in Master.Columns{
	SeparateData.Main[a]:=[]
	RanData:=[],CC:=0
	Loop,%Count%{
		RanData.Push(OO:=[])
		for c,d in b{
			if(d.ID="ID")
				OO[d.ID]:=++CC,OO.RowID:=CC
			else{
				if(d.Type="Checkbox"){
					Random,Random,0,1
					OO[d.ID]:=Random
				}else{
					Random,Random,1,500
					OO[d.ID]:="Value " Random
				}
			}
		}
	}
	Master.BuildBody(RanData,a,1)
}Search()
return
HTML(){
	Master.m(Clipboard:=RegExReplace(Master.Doc.Body.OuterHTML,"<","`n<"))
}
LVReport(Action,Value,Node){
	t("Function: " A_ThisFunc,"Label: " A_ThisLabel,"Line: " A_LineNumber,"",Action,Value,Node)
	SetTimer,KillT,-1000
	return
	KillT:
	t()
	return
}
Switch(){
	global
	Backup:=[]
	SeparateData[Displays[CurrentDisplay]]:=Master.Data
	CurrentDisplay:=CurrentDisplay+1>Displays.Count()?1:CurrentDisplay+1
	Func(Displays[CurrentDisplay]).Call()
}
t(x*){
	for a,b in x
		Msg.=(IsObject(b)?Master.Obj2String(b):b)"`n"
	ToolTip,%Msg%
}
Escape::
ExitApp
return
Master(Win:=1,ProgramName:="",Style:="",Options:=""){
	return Master:=New MasterGUI(Win,ProgramName,Style,Options)
}
Class MasterGUI{
	static Keep:=[]
	_Event(Name,Event){
		static Events:=[]
		Node:=Event.SrcElement,Ident:=Node.GetAttribute("Ident")
		/*
			t(Name,SubStr(Node.OuterHTML,1,500))
		*/
		if(Ident="Inner")
			return ID:=Node.ParentNode.ID,NN:=this.MainGUI[ID],NN.InnerText:="#" ID " Div.Container1{transform:translate(-" Node.ScrollLeft "px)}"
		Events.Push({Name:Name,Node:Node,this:this})
		SetTimer,MasterGUIEvent,-10
		return
		MasterGUIEvent:
		while(Obj:=Events.Pop()){
			Node:=Obj.Node,Name:=Obj.Name,this:=Obj.this,RowID:=Node.GetAttribute("RowID"),LV:=Node.GetAttribute("Listview"),Type:=Node.GetAttribute("Type"),AutoCommit:=Node.GetAttribute("AutoCommit")
			if(Type~="i)\b(Checkbox)\b"||Node.NodeName~="i)\b(Input)\b")
				Value:=Type="Checkbox"?(Node.Checked?-1:0):Node.Value
			if(Node.NodeName="Input"&&Name="Click"&&Type!="Checkbox")
				return
			if(Name="OnInput"||(Name="Click"&&Type="Checkbox")){
				if(Function:=Func("Commit"))
					Function.Call(Name,Node)
				if(this.ACommit||AutoCommit)
					this.Data[LV,RowID,Node.ID]:=Value ;,t("Function: " A_ThisFunc,"Label: " A_ThisLabel,"Line: " A_LineNumber,"",LV,RowID,Node.ID)
				if(!IsObject(OO:=this.ChangedObj[LV]))
					OO:=this.ChangedObj[LV]:=[]
				if(this.Data[LV,RowID,Node.ID]=Value){
					if(this.IsLV(Node)){
						Node.ParentNode.Style.BackgroundColor:="",this.ChangedObj[LV,RowID].Delete(Node.ID)
					}else{
						Node.Style.BackgroundColor:="",this.ChangedObj[LV,RowID].Delete(Node.ID)
					}
				}else{
					if(this.IsLV(Node)){
						Node.ParentNode.Style.Background:=this.Changed,OO[RowID,Node.ID]:=Value
					}else{
						Node.Style.Background:=this.Changed,OO[RowID,Node.ID]:=Value
					}
			}}if(Function:=Node.GetAttribute("Function")){
				Func(Function).Call(Name,Value,Node) ;,t("Function: " A_ThisFunc,"Label: " A_ThisLabel,"Line: " A_LineNumber,Function)
			}else if(IsFunc("Actions"))
				Func("Actions").Call(Name,Value,Node)
			if(Label:=Node.GetAttribute("Label"))
				SetTimer,%Label%,-1
			if(Timer:=Node.GetAttribute("Timer"))
				SetTimer,% Obj.this.Timers[Timer].Name,% Obj.this.Timers[Timer].Period
			if(Name="Click"){
				if(LV:=this.IsLV(Node)){
					LV:=LV.GetAttribute("Listview")
					if(!GetKeyState("Shift","P")&&!GetKeyState("Ctrl","P"))
						this.Selected[LV]:={(RowID):1}
					else if(GetKeyState("Shift","P")){
						if((Current:=this.LastSelected[LV])="")
							return this.Selected[LV,RowID]:=1,this.SetSel(LV,RowID)
						this.Selected[LV]:=[],Last:=Current,Last:=Last?Last:1,Min:=Last<RowID?Last:RowID,Max:=Last>RowID?Last:RowID
						for a,b in (this.Data[LV]){
							if(b.RowID<Min)
								Continue
							if(b.RowID>Max)
								Break
							if(b.RowID>=Min&&b.RowID<=Max)
								this.Selected[LV,b.RowID]:=1
					}}if(GetKeyState("Ctrl","P"))
						this.Selected[LV].HasKey(RowID)?this.Selected[LV].Delete(RowID):this.Selected[LV,RowID]:=1
					this.SetSel(LV,RowID)
		}}}return
	}_HTML(Node:=""){
		this.m(Clipboard:=RegExReplace(Node?Node.OuterHtml:Master.Doc.Body.OuterHTML,"<","`n<"))
	}__New(Win:=1,ProgramName:="",Style:="",Options:=""){
		static
		SetWinDelay,-1
		for a,b in {Background:"Black",Highlight:"#333",SelectedColor:"#999",Color:"Grey",Changed:"Red",HeaderColor:"Orange",Size:15}
			this[a]:=b
		for a,b in Style
			this[a]:=b
		Gui,%Win%:Destroy
		Gui,%Win%:Default
		Gui,Margin,0,0
		Gui,Color,0,0
		Gui,+HWNDMHWND +Resize
		for a,b in Options
			if(a="GUI")
				Gui,%b%
		this.MainGUI:=[],this.FixIE(11)
		Gui,Add,ActiveX,vMain HWNDMainHWND w500 h300,about:blank
		this.FixIE(),this.Win:=Win
		Gui,+LabelMasterGUI.
		this.Doc:=Main.Document,this.HWND:=MHWND,this.ID:="ahk_id"MHWND,this.WB:=Main
		this.ChangedObj:=[],this.Columns:=[],this.Data:=[],this.ProgramName:=ProgramName,this.Selected:=[],this.SelectedCSS:=[],this.Styles:=[],this.StylesObj:=[],this.Timers:=[],this.Controls:={Main:{HWND:MainHWND,ID:"ahk_id"MainHWND}}
		MasterGUI.Keep[Win]:=this
		this.Hotkeys({Delete:this.Delete.Bind(this),"+Delete":this.Del.Bind(this)
				   ,Tab:this.Tab.Bind(this),"+Tab":this.TabShift.Bind(this)})
	}AddCSS(Selector,Declarations:=""){
		if(Selector&&!Declarations)
			RegExMatch(Selector,"OUi)(.*)(\{.*\})",Found),Selector:=Found.1,Declarations:=Found.2
		if(!Obj:=this.Styles[Selector])
			Obj:=this.Styles[Selector]:=[]
		if(!IsObject(Declarations)&&Declarations){
			Info:=Trim(Declarations,"{}")
			for a,b in StrSplit(Info,";"){
				OO:=StrSplit(b,":")
				Obj[OO.1]:=OO.2
			}
		}if(IsObject(Declarations))
			this.Styles[Selector]:=Declarations
		this.SetCSS(Selector)
	}AutoCommit(OnOff:=0){
		this.ACommit:=OnOff
	}BuildLV(ListView,Columns:="",Data:=""){
		Build:=1
		this.Columns[Listview]:=Columns
		for a,b in Columns{
			for c,d in b{
				if(!this.Columns[ListView,a,c]){
					Build:=1
					Break
				}
			}
		}Header:=this.Doc.QuerySelector("#"(ListView)" .Container1"),Body:=this.Doc.QuerySelector("#"(ListView)" .Container2")
		if(Build){
			Second:=Head:="<Table Name='"(ListView)"'><THead Class='FixedHeader'><TR Class='Header'>"
			for a,b in this.Columns[ListView]
				Spans.="<TH><Span Class='Header' ListView='"(ListView)"' Function='SortHDR' OText='"(b.ID)"' ID='"(b.ID)"'>"(b.Name)"</Span></TH>",Second.="<TH>"(b.Name)"</TH>"
			Head.="</TR></thead></Table>",Second.="</TR></THead><TBody></TBody>",Header.InnerHTML:=Head,Header.QuerySelector("TR").InnerHTML:=Spans,Body.InnerHTML:=Second,ComObjError(0)
			if(!this.SelectedCSS[Listview])
				this.SelectedCSS[Listview]:=this.CreateElement("Style")
			ComObjError(1)
		}if(!Columns.Count())
			Header.InnerHTML:="",Body.InnerHTML:=""
		if(Data)
			this.BuildBody(Data,ListView,1)
		this.FixColumnHeaders(),this.LabelOrder(),this.Columns[Listview]:=Columns
		return Data
	}BuildBody(Data,Listview,AutoAdd:=""){
		New:=this.Data[Listview]:=[]
		this.LastSelected[Listview]:=""
		/*
			while(this.Doc.ReadyState!=4&&this.Doc.ReadyState!="Complete"){
				Sleep,10
			}
		*/
		this.SelectedCSS[Listview].InnerText:=""
		/*
			this.SelectedCSS.InnerText:=""
		*/
		for a,b in Data{
			BodyHTML.="<TR Listview='"(Listview)"' Row='"(A_Index)"'"(b.ID?" ID='"(b.ID)"'":"")">",this.PadID:=StrLen(Data.Count()),ID:=New.Push(OO:=[]),OO.RowID:=b.RowID
			for c,d in this.Columns[ListView]{
				OO[d.ID]:=(d.Type="Checkbox"?(b[d.ID]?-1:0):b[d.ID]),Value:=((Val:=this.ChangedObj[Listview,b.ID,d.ID])!="")?Val:b[d.ID],Value:=d.ID="Hotkey"?this.Convert_Hotkey(Value):Value,Style:=Val!=""?"Background-Color:Red":"",Style.=Style?";Text-Align:Center":"Text-Align:Center"
				if(d.Type="Input")
					BodyHTML.="<TD RowID='"(b.ID)"' ID='"(d.ID)"' "(Style?"Style='"(Style)"'":"")"><Input ListView='"(ListView)"' RowID='"(b.ID)"' Function='LVReport' ID='"(d.ID)"' Value='"(Value)"' Type='Text' oninput='OnInput(event)'"(Val?" Style='"(d.Style)"'":"")"></Input></TD>"
				else if(d.Type="Checkbox")
					BodyHTML.="<TD RowID='"(b.ID)"' ID='"(d.ID)"' "(Style?"Style='"(Style)"'":"")"><Input ListView='"(ListView)"' RowID='"(b.ID)"' Function='LVReport' ID='"(d.ID)"' Type='Checkbox'"(Value?"Checked":"")"></Input></TD>"
				else if(d.Type="DDL"){
					this.m("Function: " A_ThisFunc,"Line: " A_LineNumber,"Not yet implemented")
					/*
						Item:="<Select Label='" d.Label "' onchange='OnInput(Event)' Column='" Column++ "' " AddAtt ">"
						for g,h in d.Obj
							Item.="<Option Value='" h "'" (h=d.Text?" selected='selected'":"")">" h "</Option>"
						Row.="<TD ID='" b.Equipment "_Condition' oninput='OnInput(Event)' Value='" d.Text "'>" Item "</TD>"
						if(){
							m(Clipboard:=Row,"",b)
							
							ExitApp
						}
					*/
				}else if(d.Type="Date"){
					BodyHTML.="<TD ID='"(d.ID)"' "(Style?"Style='"(Style)"'":"")"><Input Type='Date' ListView='"(ListView)"' RowID='"(b.ID)"' Function='LVReport' ID='"(d.ID)"' Value='"(Value)"' oninput='OnInput(event)'"(d.Style?" Style='"(d.Style)"'":"")"></Input></TD>"
				}else if(d.Type="Text"){
					BodyHTML.="<TD RowID='"(b.ID)"' ID='"(d.ID)"' "(Style?"Style='"(Style)"'":"")">"(Value)"</TD>"
				}else
					this.m("Function: " A_ThisFunc,"Line: " A_LineNumber,"",d.Type " Has not yet been implemented")
			}BodyHTML.="</TR>"
		}if(AutoAdd)
			this.Doc.QuerySelector("#"(ListView)" .Container2").GetElementsByTagName("TBody").Item[0].InnerHTML:=BodyHTML,this.LabelOrder(),this.FixColumnHeaders()
		else
			return BodyHTML
	}Close(){
		MasterGUI.Keep.Escape()
	}Convert_Hotkey(Key){
		StringUpper,Key,Key
		for a,b in [{Ctrl:"^"},{Win:"#"},{Alt:"!"},{Shift:"+"}]
			for c,d in b
				if(InStr(Key,d))
					Build.=c "+",Key:=RegExReplace(Key,"\" d)
		return Build Key
	}CreateElement(Type,Parent:="",Atts:="",Style:="",Text:="",HTML:=""){
		if(Type="Listview")
			New:=this.CreateElement("Div",Parent),New.InnerHTML:=this.LVHTML(Text),this.MainGUI[Text]:=this.CreateElement("Style"),this.MainGUI[Text].InnerText:="#"(Text)" Div.Container1{transform:translate(0px)}"
		else
			New:=this.Doc.CreateElement(Type),(Parent?Parent:this.Doc.Body).AppendChild(New),(Text)?New.InnerText:=Text:HTML?New.InnerHTML:=HTML:""
		for a,b in Atts
			(a="Timer")?(this.Timers[b.ID]:={Name:b.Name,Period:b.Period},New.SetAttribute("Timer",b.ID)):New.SetAttribute(a,b)
		for a,b in Style
			Style:=New.Style,Style[a]:=b
		if(Type="Input")
			New.SetAttribute("oninput","OnInput(event)")
		return New
	}Del(Items:=""){
		Remove:=[]
		for a,b in (Items?Items:this.DelBuild())
			LV:=b.LV,b.Node.ParentNode.RemoveChild(b.Node),RowID:=b.Node.QuerySelector("*[RowID]").GetAttribute("RowID"),Remove[RowID]:=1
		Associate:=[]
		for a,b in this.Data[LV]
			if(Remove[b.RowID])
				Associate[a]:=1
		for a,b in Associate
			this.Data[LV].Delete(a)
		this.LabelOrder(),this.SelectedCSS[LV].InnerText:=""
	}DelBuild(){
		Node:=this.Doc.ActiveElement,Delete:=[]
		if(LV:=this.IsLV(Node).GetAttribute("Listview")){
			for a,b in this.Selected[LV]{
				Delete.Push({LV:LV,RowID:a,Node:this.Doc.QuerySelector("Div[Listview='"(LV)"'] TD[RowID='"(a)"']").ParentNode})
			}
		}return Delete
	}Delete(){
		if(!(Obj:=this.DelBuild()).Count())
			return
		if(this.m("Delete "(Obj.Count())" item"(Obj.Count()=1?"":"s"),"Are you sure?","Btn:yn","Def:2")="YES")
			this.Del(Obj)
	}DeleteCSS(Selector,Declaration){
		if(!this.Styles[Selector,Declaration])
			return
		this.Styles[Selector].Delete(Declaration)
		this.SetCSS(Selector)
	}Escape(){
		this:=MasterGUI.Keep
		this.GetLast()
		if(this.Changed.MinIndex()){
			if((Result:=this.m("Saving changes?","btn:ync","def:3"))="Cancel")
				return
			if(Result="No")
				ExitApp
			if(Result="Yes")
				this.m("Save the changes!")
		}else
			ExitApp
	}EvenCSS(Color,Listview:="",Extra:=""){
		this.AddCSS((Listview?"Div[Listview='"(Listview)"'] ":"")"TBody tr:nth-child(odd){Background-Color:"(Color)";"(Extra)"}")
	}FixColumnHeaders(){
		All:=this.Doc.GetElementsByClassName("Outer")
		AllObj:=[]
		while(aa:=All.Item[A_Index-1]){
			All1:=aa.GetElementsByTagName("Div"),AllObj.Push(OO:=[])
			while(aa1:=All1.Item[A_Index-1])
				if(InStr(aa1.ID,"Container"))
					OO[RegExReplace(aa1.ID,"\D")]:=aa1
		}
		for a,b in AllObj{
			Start:=2,All:=b.2.GetElementsByTagName("TH"),Fix:=b.1.GetElementsByTagName("Span")
			ComObjError(0)
			while(aa:=All.Item[A_Index-1]){
				Rect:=aa.GetBoundingClientRect()
				Width:=Rect.Right-Rect.Left
				Fix[A_Index-1].Style.Left:=Start
				Fix[A_Index-1].Style.Width:=Width
				Start+=Width
			}
			ComObjError(1)
		}
	}FixIE(Version=0){
		static Key:="Software\Microsoft\Internet Explorer\MAIN\FeatureControl\FEATURE_BROWSER_EMULATION",Versions:={7:7000,8:8888,9:9999,10:10001,11:11001}
		Version:=Versions[Version]?Versions[Version]:Version
		if(A_IsCompiled)
			ExeName:=A_ScriptName
		else
			SplitPath,A_AhkPath,ExeName
		RegRead,PreviousValue,HKCU,%Key%,%ExeName%
		if(!Version)
			RegDelete,HKCU,%Key%,%ExeName%
		else
			RegWrite,REG_DWORD,HKCU,%Key%,%ExeName%,%Version%
		return PreviousValue
	}GetLast(){
		Settings:=[]
		for a,b in v.Keys{
			if(this.Doc.QuerySelector("#Box #"(a)).Checked){
				Settings.Push({Key:"LastType",Value:a})
				Break
			}
		}
		Settings.Push({Key:"LastClip",Value:this.Current.1.GetAttribute("RowID")})
		if(Settings.1)
			DB.Insert("Settings",Settings,"Key")
	}Hotkeys(Keys){
		Hotkey,IfWinActive,% this.ID
		for a,b in Keys
			Hotkey,%a%,%b%,On
	}IsLV(Node){
		while(Node){
			if(Node.NodeName="TR")
				return Node
			Node:=Node.ParentNode
		}
	}LabelOrder(){
		All:=this.Doc.All,this.TabOrder:=[],Row:=0,Column:=0
		while(aa:=All.Item[A_Index-1]){
			ListView:=aa.GetAttribute("Listview")
			if(Listview&&Row)
				RowID:=aa.QuerySelector("*[RowID]").GetAttribute("RowID")
			if(aa.NodeName="Button")
				aa.SetAttribute("Row",Row),aa.SetAttribute("Col",Column)
			if(aa.NodeName="TR")
				aa.SetAttribute("Row",Row)
			if(aa.NodeName="Input"||aa.NodeName="Select"){
				if(aa.GetAttribute("Name")&&aa.GetAttribute("Name")=LastName){
					aa.SetAttribute("Row",Row),aa.SetAttribute("Column",Column)
					Continue
				}if(!aa.ParentNode.ParentNode.IsSameNode(LastParent))
					Row++,Column:=1
				aa.SetAttribute("Row",Row)
				this.TabOrder[Row,Column]:=aa
				aa.SetAttribute("Col",Column++)
				LastParent:=aa.ParentNode.ParentNode
				LastName:=aa.GetAttribute("Name")
				ID:=aa.GetAttribute("RowID")
				if(Value:=this.Changed[Row,ID])
					aa.Value:=Value,aa.ParentNode.Style.BackgroundColor:="Red"
			}
		}
	}
	LVDelete(ListView,Items:=""){
		if(!Items)
			return Node:=this.Doc.QuerySelector("Div[Listview='"(Listview)"'] TBody"),Parent:=Node.ParentNode,Parent.RemoveChild(Node),this.CreateElement("TBody",Parent)
		
	}LVHTML(ListView,Width:="calc(100% - 2px)",Height:="calc(100% - 2px)"){
		Total.="<Div Class='Outer' ID='" ListView "' Listview='"(Listview)"' Style='Width:"(Width)";Height:"(Height)"'><Div ID='Container1' Class='Container1'></Div><Div Class='Inner' onscroll='scroll(event)' ID='Inner' Ident='Inner' Style='Width:100%'><Div ID='Container2' Class='Container2' onscroll='scroll(event)'></Div></Div></Div>"
		return Total
	}m(x*){
		static List:={Btn:{OC:1,ARI:2,YNC:3,YN:4,RC:5,CTC:6},Ico:{"x":16,"?":32,"!":48,"i":64}},Msg:=[],Title
		List.Title:=this.ProgramName,List.Def:=0,List.Time:=0,Value:=0,Txt:=""
		WinGetTitle,Title,A
		for a,b in x
			Obj:=StrSplit(b,":"),(VV:=List[Obj.1,Obj.2])?(Value+=VV):(List[Obj.1]!="")?(List[Obj.1]:=Obj.2):TXT.=(b.XML?b.XML:IsObject(b)?this.Obj2String(b):b) "`n"
		Msg:={Option:Value+262144+(List.Def?(List.Def-1)*256:0),Title:List.Title,Time:List.Time,Txt:Txt}
		Sleep,120
		MsgBox,% Msg.Option,% Msg.Title,% Msg.Txt,% Msg.Time
		for a,b in {OK:value?"OK":"",Yes:"YES",No:"NO",Cancel:"CANCEL",Retry:"RETRY"}
			IfMsgBox,%a%
		return b
		return
	}MinSize(W:=100,H:=100){
		Gui,% this.Win ":+MinSize"(W)(H?"x"(H):"")
	}Obj2String(Obj,FullPath:=1,BottomBlank:=0){
		static String,Blank
		if(FullPath=1)
			String:=FullPath:=Blank:=""
		Try{
			if(Obj.XML){
				String.=FullPath Obj.XML "`n",Current:=1
			}
		}
		Try{
			if(Obj.OuterHtml){
				String.=FullPath Obj.OuterHtml "`n",Current:=1
			}
		}if(!Current){
			if(IsObject(Obj)){
				for a,b in Obj{
					if(IsObject(b)&&b.OuterHtml)
						String.=FullPath "." a " = " b.OuterHtml "`n"
					else if(IsObject(b)&&!b.XML)
						this.Obj2String(b,FullPath "." a,BottomBlank)
					else{
						if(BottomBlank=0)
							String.=FullPath "." a " = " (b.XML?b.XML:b) "`n"
						else if(b!="")
							String.=FullPath "." a " = " (b.XML?b.XML:b) "`n"
						else
							Blank.=FullPath "." a " =`n"
					}
				}
			}
		}	
		return String Blank
	}OddCSS(Color,Listview:="",Extra:=""){
		this.AddCSS((Listview?"Div[Listview='"(Listview)"'] ":"")"TBody tr:nth-child(even){Background-Color:"(Color)";"(Extra)"}")
	}QuerySelector(Query){
		return this.Doc.QuerySelector(Query)
	}Reset(HTML:=""){
		this.WB.Navigate("about:blank")
		while(this.WB.ReadyState!=4)
			Sleep,10
		Font:="Color:"(this.HeaderColor)";Font-Size:" this.Size "px",this.Doc.Body.OuterHTML:="<Body Style='Width:calc(100% - 4);Margin:0px;' ondrop='return false;'>",this.Doc.Body.InnerHTML:=HTML,this.AddCSS("Body{"(Font)"}"),this.AddCSS(".Container1 TH{Visibility:Hidden}"),this.AddCSS(".Outer{Border:1px Solid Grey;OverFlow:Hidden;Display:Block}"),this.AddCSS("TH Span{White-Space:NoWrap;Visibility:Visible;Position:Absolute;Text-Align:Center;"(Font)"}"),this.AddCSS(".Inner{OverFlow:Auto;Width:100%;Height:calc(100% - "(this.Size)"px);Margin-Top:"(this.Size)"px}"),this.AddCSS(".Container2 TD{White-Space:NoWrap}"),this.AddCSS(".Container2 TH{White-Space:NoWrap;Visibility:Hidden;Line-Height:0px;"(Font)"}")
		for a,b in {onclick:"Click",ondblclick:"DoubleClick",scroll:"scroll",OnInput:"OnInput",Change:"Change",Search:"Search"}
			this.CreateElement("Script").InnerText:=a "=function(" a "){ahk_event('" b "',event)};"
		for a,b in ["td{Border:1px Solid Grey;Padding:8px}","Body{Background-Color:"(this.Background)";Color:"(this.Color)";-MS-User-Select:None}","Table{Border-Collapse:Collapse;Border-Spacing:0;Width:100%}","Input:Focus{Background:#444;Color:#FFF;Border:2px Solid Orange}","Input{Background:"(this.Background)";Color:"(this.Color)"}",".Title{Color:"(this.TitleColor)"}"]
			this.AddCSS(b)
		this.Columns:=[],this.Data:=[],this.LastSelected:=[],this.Styles:=[],this.StylesObj:=[],this.SelectedCSS:=[]
		return this.Doc.ParentWindow.ahk_event:=this._Event.Bind(this)
	}SetSel(LV,RowID){
		static LastSel:=[]
		if(!LV)
			return
		for a,b in this.Selected[LV]
			Sel.="TR[Listview='"(LV)"'] TD[RowID='"(a)"']{Background-Color:"(this.Highlight)"}`n"
		this.SelectedCSS[LV].InnerText:=Sel
		this.LastSelected[LV]:=RowID
		LastSel[LV]:=this.Selected[LV].Clone()
	}Show(x:="Center",y:="Center",w:=200,h:=200){
		Gui,% this.Win ":Show",x%x% y%y% w%w% h%h%,% this.ProgramName
		this.Size(),this.Tab()
	}Size(Info:="",W:="",H:=""){
		static WW,HH
		this:=IsObject(this)?this:(MasterGUI.Keep[A_Gui]),(W&&H)?(WW:=W,HH:=H):!W||!H?(W:=WW,H:=HH):"",DllCall("SetWindowPos",UPtr,this.Controls.Main.HWND,Int,0,"Int",0,"Int",0,"Int",W,"Int",H,"UInt",0x0020),this.FixColumnHeaders()
	}SetCSS(Selector){
		for a,b in this.Styles[Selector]
			String.=a ":" b ";"
		if(!Node:=this.StylesObj[Selector])
			Node:=this.CreateElement("Style"),this.StylesObj[Selector]:=Node
		Node.InnerText:=Selector "{"(String)"}"
	}Tab(Add:=1){
		Node:=this.Doc.ActiveElement,Row:=Node.GetAttribute("Row"),Col:=Node.GetAttribute("Col")
		if(Row=""&&Col=""){
			Node:=this.QuerySelector("*[Row='"(this.TabOrder.MaxIndex())"'][Col='"(this.TabOrder[this.TabOrder.MaxIndex()].MaxIndex())"']")
		}else{
			if(!Node:=this.QuerySelector("*[Row='"(Row)"'][Col='"(Col+1)"']"))
				Node:=this.QuerySelector("*[Row='"(Row+1)"'][Col='"this.TabOrder[Row+1].MinIndex()"']")
			if(!Node)
				Node:=this.QuerySelector("*[Row='"(this.TabOrder.MinIndex())"'][Col='"(this.TabOrder[this.TabOrder.MinIndex()].MinIndex())"']")
		}Node.Focus()
	}TabShift(){
		Node:=this.Doc.ActiveElement,Row:=Node.GetAttribute("Row"),Col:=Node.GetAttribute("Col")
		if(Row=""&&Col=""){
			Node:=this.QuerySelector("*[Row='"(this.TabOrder.MaxIndex())"'][Col='"(this.TabOrder[this.TabOrder.MaxIndex()].MaxIndex())"']")
		}else{
			if(!Node:=this.QuerySelector("*[Row='"(Row)"'][Col='"(Col-1)"']"))
				Node:=this.QuerySelector("*[Row='"(Row-1)"'][Col='"this.TabOrder[Row-1].MaxIndex()"']")
			if(!Node)
				Node:=this.QuerySelector("*[Row='"(this.TabOrder.MaxIndex())"'][Col='"(this.TabOrder[this.TabOrder.MaxIndex()].MaxIndex())"']")
		}Node.Focus()
	}
}