#tag ClassProtected Class AppInherits Application	#tag Event		Sub Close()		  // Checks if RememberPassword is check and erases password if not.		  If  app.prefs.root.GetBoolean("RememberPassword",false) = false then		    app.prefs.root.SetString("Password","")		  else		    // Encode and Store Password		    app.prefs.root.SetString("Password",encodebase64(mempassword))		  end if		  // Save Preferences		  app.prefs.Save		End Sub	#tag EndEvent	#tag Event		Sub Open()		  //You can pass a FolderItem for Sparkle.framework, or you can pass nil.  In this case, Sparkle will look for Sparkle.framework		  //in the Frameworks subdirectory of the app bundle, in ~/Library/Frameworks, and in /Library/Frameworks.		  		  dim SparkleFrameworkLocation as FolderItem = nil		  Sparkle.Initialize SparkleFrameworkLocation		  Sparkle.FoundVersionHandler = AddressOf HandleSparkleFoundVersion		  Sparkle.CancelQuitHandler = AddressOf HandleSparkleCancelQuit		  		  //Create Plist File		  dim f As FolderItem		  f=SpecialFolder.Preferences.child("com.chikorita157sanimeblog.malclientosx.plist")		  prefs=new plist(f)		  		  //setting this will prevent problems with unhandled NSExceptions		  //Load approperate Sparkle Appcast URL		  If app.prefs.root.GetBoolean("ExpUpdates",false) = true then		    // Load Experimental Branch Appcast		    Sparkle.UserDefault("SUFeedURL") = "http://chikorita157.notcliche.com/malclientosx/appcastexp.xml"		  else		    //Load Stable Branch Appcast		    Sparkle.UserDefault("SUFeedURL") = "http://chikorita157.notcliche.com/malclientosx/appcast.xml"		  end if		  		  //Register Help File		  Dim isReg As Boolean		  		  //Register your Help Book with the Mac OS X system.		  isReg = HelpRunner.RegisterAppleHelp		  		  // Check Login		  If app.prefs.root.GetBoolean("AutoLogin",false) = true then		    //Start auto login		    // using API to check credentials		    Dim socket1 as New HTTPSocket		    dim data as string		    If checkkeychain = true then		      mempassword = loadpassword		      memusername = app.prefs.root.GetString("Username")		      //mempassword = DecodeBase64(app.prefs.root.GetString("Password"))		      loginenc = EncodeBase64(memusername + ":" + mempassword)		      socket1.setrequestheader "Authorization","Basic " + loginenc		      //data= socket1.get("http://mal-api.com/account/verify_credentials",10)		      data = socket1.get("http://myanimelist.net/api/account/verify_credentials.xml", 10)		      If socket1.httpstatuscode = 200 then		        Window1.show		      Elseif socket1.httpstatuscode = 204 then		        errboxshowdialog("MAL Client OS X was unable to log you in since you don't have the correct Username and/or Password.","Check your username and password and try logging in again. If you recently changed your password, enter your new password and try logging in.")		        loginenc = ""		        Window2.show		      else		        errboxshowdialog("MAL Client OS X was unable to log you in since it cannot connect to the server. ", "Check your internet connection and try logging in again.")		        loginenc = ""		        Window2.show		      end if		    else		      errboxshowdialog("MAL Client OS X was unable to log you in since no keychain exists or the keychain is locked.", "Please reenter your password and try again. If your keychain is locked, unlock it and try again.")		      loginenc = ""		      Window2.show		    end if		  else		    Window2.show		  end if		  		End Sub	#tag EndEvent	#tag Event		Function UnhandledException(error As RuntimeException) As Boolean		  dim f as new errorreporting(error)		  f.ShowModal		  return true		End Function	#tag EndEvent	#tag MenuHandler		Function EditPreferences() As Boolean Handles EditPreferences.Action			winprefs.show			Return True					End Function	#tag EndMenuHandler	#tag MenuHandler		Function FileAboutMALClientOSX() As Boolean Handles FileAboutMALClientOSX.Action						Carbon.ShowAboutBox kAppName,  "Version " + app.shortVersion, "", kAppCopyrightPrefix + kAppAuthorName + EndOfLine +  "All rights reserved."			return true					End Function	#tag EndMenuHandler	#tag MenuHandler		Function FileCheckforUpdates() As Boolean Handles FileCheckforUpdates.Action			Sparkle.CheckForUpdates true			Sparkle.CheckStatus			Return True					End Function	#tag EndMenuHandler	#tag MenuHandler		Function HelpMALClientOSXHelp() As Boolean Handles HelpMALClientOSXHelp.Action						Return True					End Function	#tag EndMenuHandler	#tag MenuHandler		Function HelpMALClientOSXMALClub() As Boolean Handles HelpMALClientOSXMALClub.Action			ShowURL "http://myanimelist.net/clubs.php?cid=16059"						Return True					End Function	#tag EndMenuHandler	#tag MenuHandler		Function HelpMALClientOSXWebsite() As Boolean Handles HelpMALClientOSXWebsite.Action			ShowURL "http://chikorita157.notcliche.com/malclientosx/"			Return True					End Function	#tag EndMenuHandler	#tag MenuHandler		Function HelpView() As Boolean Handles HelpView.Action			ShowURL "http://chikorita157.notcliche.com/malclientosx/help/"			Return True					End Function	#tag EndMenuHandler	#tag MenuHandler		Function lookup() As Boolean Handles lookup.Action			lookupwindow.show			Return True					End Function	#tag EndMenuHandler	#tag MenuHandler		Function MyAnimeListExportAnimeList() As Boolean Handles MyAnimeListExportAnimeList.Action			dim ex as new exportwin			ex.ShowModalWithin(Window1.truewindow)			ex.close		End Function	#tag EndMenuHandler	#tag MenuHandler		Function MyAnimeListIndustryNews() As Boolean Handles MyAnimeListIndustryNews.Action			showurl "http://myanimelist.net/news.php"			Return True					End Function	#tag EndMenuHandler	#tag MenuHandler		Function MyAnimeListLookupMembersList() As Boolean Handles MyAnimeListLookupMembersList.Action						memberlistwindow.show			Return True					End Function	#tag EndMenuHandler	#tag MenuHandler		Function MyAnimeListLookupMembersMangaList() As Boolean Handles MyAnimeListLookupMembersMangaList.Action			mangalist.show			Return True					End Function	#tag EndMenuHandler	#tag MenuHandler		Function MyAnimeListViewYourAnimeList() As Boolean Handles MyAnimeListViewYourAnimeList.Action			ShowURL "http://myanimelist.net/animelist/" + app.prefs.root.GetString("Username")			Return True					End Function	#tag EndMenuHandler	#tag MenuHandler		Function MyAnimeListViewYourMangaList() As Boolean Handles MyAnimeListViewYourMangaList.Action			ShowURL "http://myanimelist.net/mangalist/" + app.prefs.root.GetString("Username")			Return True					End Function	#tag EndMenuHandler	#tag MenuHandler		Function MyAnimeListYourPanel() As Boolean Handles MyAnimeListYourPanel.Action			ShowURL "http://myanimelist.net/panel.php"			Return True					End Function	#tag EndMenuHandler	#tag MenuHandler		Function RefreshYourList() As Boolean Handles RefreshYourList.Action			// Refreshes the list every 15 minutes			window1.refreshlist(false)			Window1.Timer1.Reset			Return True					End Function	#tag EndMenuHandler	#tag MenuHandler		Function UntitledViewYourProfile() As Boolean Handles UntitledViewYourProfile.Action			ShowURL "http://myanimelist.net/profile/" + app.prefs.root.GetString("Username")			Return True					End Function	#tag EndMenuHandler	#tag MenuHandler		Function WindowMenu() As Boolean Handles WindowMenu.Action						Return True					End Function	#tag EndMenuHandler	#tag Method, Flags = &h21		Private Function HandleSparkleCancelQuit() As Boolean		  return true		End Function	#tag EndMethod	#tag Method, Flags = &h21		Private Sub HandleSparkleFoundVersion(isNew as Boolean, version as String)		  break		End Sub	#tag EndMethod	#tag Method, Flags = &h0		Sub lookupwindowshow(aniid as string,list as string)		  // Show the lookup window using the AniID selected		  Dim lookup as new lookupwindow		  lookup.SeriesID =aniid		  lookup.listtype = list		  if lookup.listtype = "Anime" then		    lookup.loadinfo		  else		    lookup.loadmanga		  end if		  		End Sub	#tag EndMethod	#tag Note, Name = Notes		Project is under the GNU Public Licence V3. If you made any modifications, you must license this project under the GPL V3 to avoid GPL violation.				This project does run in Windows with some glitches, but is not supported. You need to remove anything Mac OS X related (Maclib, Sparkle, MacWindowMenu) before it can compile for Windows.	#tag EndNote	#tag Property, Flags = &h0		loginenc As string	#tag EndProperty	#tag Property, Flags = &h0		MemPassword As string	#tag EndProperty	#tag Property, Flags = &h0		MemUsername As String	#tag EndProperty	#tag Property, Flags = &h0		prefs As plist	#tag EndProperty	#tag Constant, Name = kEditClear, Type = String, Dynamic = False, Default = \"&Delete", Scope = Public		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"&Delete"		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"&Delete"	#tag EndConstant	#tag Constant, Name = kFileQuit, Type = String, Dynamic = False, Default = \"&Quit", Scope = Public		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"E&xit"	#tag EndConstant	#tag Constant, Name = kFileQuitShortcut, Type = String, Dynamic = False, Default = \"", Scope = Public		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"Cmd+Q"		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"Ctrl+Q"	#tag EndConstant	#tag ViewBehavior		#tag ViewProperty			Name="loginenc"			Group="Behavior"			Type="string"			EditorType="MultiLineEditor"		#tag EndViewProperty		#tag ViewProperty			Name="MemPassword"			Group="Behavior"			Type="string"			EditorType="MultiLineEditor"		#tag EndViewProperty		#tag ViewProperty			Name="memusername"			Group="Behavior"			Type="String"			EditorType="MultiLineEditor"		#tag EndViewProperty	#tag EndViewBehaviorEnd Class#tag EndClass