// Cody Stebbins
// MIT License
// Contact mail@codystebbins.com for help!

// General
key user; // UUID of current user

// Trivia
integer gListener; // Listener for current dialog
string currentAnswer;
list close = ["Close"]; // Close options

promptText(string message, string answer) {
    currentAnswer = answer;
    // Send a dialog to that person on the -99 channel.
    llTextBox(user, message, -99);
    // Start a one-minute timer, after which we will stop listening for responses
    llSetTimerEvent(60);  
}

dialog(string message, list options) {
    // Send a dialog to that person on the -99 channel.
    llDialog(user, message, options, -99);
    // Start a one-minute timer, after which we will stop listening for responses
    llSetTimerEvent(60);  
}  
 
default {
    
    on_rez(integer p) { llResetScript(); }
    
    state_entry() {}
    
    touch_start(integer totalNumber) {   
        // Kill off current listeners
        llListenRemove(gListener);
        
        // Get user UUID & setup listener
        user = llDetectedKey(0);
        gListener = llListen(-99, "", user, "");
        
        promptText("Fill in the blank! 'User _________ is an important part of privacy since technologies need to educate their users on how and when information is collected to build trust.'", "awareness");
    }
    
    listen(integer chan, string name, key id, string msg) {
        msg = llToLower(msg);
        if (msg == currentAnswer) {        
            dialog("Nice job! The second letter is 'S'", close);
        } else {
            dialog("Incorrect answer! Try again.", close);
        }   
        
        llListenRemove(gListener); 
    }
    
}
