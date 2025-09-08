-- https://github.com/abdullahahmed-dev/custom-alfred-wezterm-script
on alfred_script(query)
	tell application "wezterm" to activate
	set paneId to do shell script "/Applications/WezTerm.app/Contents/MacOS/wezterm cli spawn"
	set commandList to paragraphs of query
	repeat with command in commandList
		do shell script "echo " & command & " | /Applications/WezTerm.app/Contents/MacOS/wezterm cli send-text --no-paste --pane-id " & paneId
	end repeat
end alfred_script