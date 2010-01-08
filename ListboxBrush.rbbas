#tag ModuleProtected Module ListboxBrush	#tag Method, Flags = &h0		Function GetThemeColor(Brush As Integer) As Color		  #if TargetMacOS		    if not system.isfunctionavailable("HIThemeBrushCreateCGColor","Carbon") then		      return &c000000		    end		    		    Soft Declare Function HIThemeBrushCreateCGColor Lib "Carbon" (inBrush As Integer, ByRef outColor As Integer) As Integer		    Soft Declare Function CGColorGetNumberOfComponents Lib "Carbon" (color As Integer) As Integer		    Soft Declare Function CGColorGetComponents Lib "Carbon" (color As Integer) As Ptr		    Soft Declare Sub CGColorRelease Lib "Carbon" (color As Integer)		    		    static lastBrush as integer		    static lastColor as color		    		    if brush = lastbrush then		      return lastcolor		    end		    		    dim colorRef as integer		    dim err as integer = HIThemeBrushCreateCGColor(brush,colorRef)		    		    dim num as integer = CGColorGetNumberOfComponents(colorRef)		    dim p as ptr = CGColorGetComponents(colorRef)		    		    		    dim components() as integer		    dim lastOffset as Integer = 4 * (num - 1)		    dim offset as integer		    for offset = 0 to lastOffset step 4		      components.Append(255 * p.Single(offset))		    next		    if num = 2 then		      // the first value repeats twice more, second is the alpha		      components.insert(1,components(0))		      components.insert(2,components(0))		    end		    while ubound(components) < 2		      components.append(255)		    wend		    		    CGColorRelease(colorRef)		    		    dim c as color = rgb(components(0),components(1),components(2))		    		    lastcolor = c		    lastbrush = brush		    		    Return c		  #else		    return &c000000		  #endif		End Function	#tag EndMethod	#tag Note, Name = About		Gives the ListBoxes a Mac OS X feel.				Part of MAL Client OS X and covered under GPL V3	#tag EndNote	#tag Constant, Name = kThemeBrushListViewEvenRowBackground, Type = Double, Dynamic = False, Default = \"57", Scope = Public	#tag EndConstant	#tag Constant, Name = kThemeBrushListViewOddRowBackground, Type = Double, Dynamic = False, Default = \"56", Scope = Public	#tag EndConstant	#tag ViewBehavior		#tag ViewProperty			Name="Index"			Visible=true			Group="ID"			InitialValue="-2147483648"			InheritedFrom="Object"		#tag EndViewProperty		#tag ViewProperty			Name="Left"			Visible=true			Group="Position"			InitialValue="0"			InheritedFrom="Object"		#tag EndViewProperty		#tag ViewProperty			Name="Name"			Visible=true			Group="ID"			InheritedFrom="Object"		#tag EndViewProperty		#tag ViewProperty			Name="Super"			Visible=true			Group="ID"			InheritedFrom="Object"		#tag EndViewProperty		#tag ViewProperty			Name="Top"			Visible=true			Group="Position"			InitialValue="0"			InheritedFrom="Object"		#tag EndViewProperty	#tag EndViewBehaviorEnd Module#tag EndModule