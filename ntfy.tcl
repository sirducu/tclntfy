
package require Tcl 8.5
echo "NTFY TCL by DuCu Loaded!"
namespace eval EmailAlert {
    variable channel_to_watch ""
    variable words_to_watch {}

    proc setchannel {irc msg args} {
        variable channel_to_watch
        set channel_to_watch [lindex $args 0]
        $irc reply "Channel set to $channel_to_watch."
    }

    proc setwords {irc msg args} {
        variable words_to_watch
        set words_to_watch [split [lindex $args 0]]
        $irc reply "Words set to [lindex $args 0]."
    }

    proc perform_command {command} {
        exec $command
    }

    proc doPrivmsg {irc msg} {
        variable channel_to_watch
        variable words_to_watch

        set target [lindex $msg 0]
        set message [lindex $msg 1]

        if {$target eq [$irc nick]} {
            set words [split $message]
            if {[llength $words] == 2} {
                set command [lindex $words 0]
                set arg [lindex $words 1]
                if {$command eq "setchannel"} {
                    setchannel $irc $msg [list $arg]
                } elseif {$command eq "setwords"} {
                    setwords $irc $msg [list $arg]
                }
            }
        } elseif {$target eq $channel_to_watch} {
            foreach word $words_to_watch {
                if {[string tolower $word] in [string tolower $message]} {
                    set curl_command "curl -d \"$message\" ntfy.sh/multirpg"
                    perform_command $curl_command
                    break
                }
            }
        }
    }
}

# Usage:
# EmailAlert::setchannel ircObject messageArgs channel
# EmailAlert::setwords ircObject messageArgs "word1 word2 word3 ..."
# EmailAlert::perform_command "command to execute"
# EmailAlert::doPrivmsg ircObject messageArgs
