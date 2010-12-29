if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn match	logText	 /.*$/
syn match	logLevel / \u\+ -/	nextgroup=logText skipwhite
syn match   logProg  /- \i\+ -/ nextgroup=logLevel skipwhite
syn match	logLine  /,\d\+ /	nextgroup=logProg skipwhite
syn match	logDate	 /\d\+-\d\+-\d\+ \d\d:\d\d:\d\d/	nextgroup=logLine skipwhite
                      "2010-10-05 00:48:21
syn match	logEntry /:\d\+:/ 	nextgroup=logDate skipwhite
syn match   logName  /^.*\.log/ nextgroup=logEntry skipwhite

"if !exists("did_syslog_syntax_inits")
  "let did_syslog_syntax_inits = 1
  hi link logDate       Statement
  hi link logText 	    Type 
  hi link logProg       Identifier 
  hi link logEntry      Include 
  hi link logName       Identifier
  hi link logLevel      String 
  hi link logLine       Comment
"endif

let b:current_syntax="pythonlog"
