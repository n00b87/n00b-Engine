Include Once

Function FindFirstOf(item$, search_string$)
	For i = 0 to length(search_string$)-1
		If Mid(search_string$, i, length(item$)) = item$ Then
			Return i
		End If
	Next
	Return -1
End Function

Function FindNextOf(item$, search_string$, start)
	If start >= length(search_string$) Then
		Return -1
	End If
	For i = start to length(search_string$) - 1
		If Mid(search_string$, i, length(item$)) = item$ Then
			Return i
		End If
	Next
	Return -1
End Function

Function FindLastOf(item$, search_string$)
	If length(search_string$) <= 0 Then
		Return -1
	End If
	last_index = -1
	For i = 0 to length(search_string$)-1
		If Mid$(search_string$, i, 1) = item$ Then
			last_index = i
		End If
	Next
	Return last_index
End Function

MAX_LIST_SIZE = 32767

Function Split(list_string$, delimeter$, ByRef list_out$)
	Dim v$[MAX_LIST_SIZE]
	
	
	list_string$ = Trim$(list_string$) + delimeter$
	
	arg$ = ""
	arg_num = 0
	
	For i = 0 to Len(list_string$)-1
		c$ = Mid(list_string$, i, 1)
		
		If c$ = delimeter$ Then
			v$[arg_num] = arg$
			arg_num = arg_num + 1
			
			arg$ = ""
		Else
			arg$ = arg$ + c$
		End If
		
	Next
	
	For i = 0 to arg_num-1
		list_out$[i] = v$[i]
	Next
	
	Return arg_num
End Function

Function InList(ByRef list$, list_count, item$)
	For i = 0 to list_count-1
		If item$ = list$[i] Then
			Return True
		End If
	Next
	Return False
End Function

