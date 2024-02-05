#!/usr/bin/tclsh
package require http
# Function to handle messages in the channel
set channel "#idlerpg"


proc handle_channel_message {nick host handle target text} {
    global channel
    # Check if the message is from the correct channel
    if {[string equal -nocase $target $channel]} {
        # Log the received message
        putlog "Received message in $channel from $nick: $text"

        # Check if the message contains the word "ducu"
        if {[string match *ducu* $text]  || [string match *lust* $text] || [string match *opTim* $text]} {
            # Define the URL for the HTTP request
            set url "http://ntfy.sh/idlerpg3"

            # Define the data to be sent in the HTTP request
            set data "$text"

            # Make an HTTP POST request with the data
            set token [::http::geturl $url -query $data]
            set response [::http::data $token]
            ::http::cleanup $token
        }
    }
}

# Bind the handle_channel_message function to handle messages in the channel
bind pubm - * handle_channel_message

# Set the channel to join
putlog "LOADED ntfyTCL by DuCu"
