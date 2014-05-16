// Cody Stebbins
// MIT License
// Contact mail@codystebbins.com for help!

// General
vector blue = <0.000, 0.455, 0.851>;
float opaque = 1.0;
key user; // UUID of current user

// Trivia
integer gListener; // Listener for current dialog
string currentAnswer;
list close = ["Close"]; // Close options

// Movement
vector currentOffset = <0,0,0.2>;
integer steps = 8;
integer up = FALSE;

move(vector offset)
{
    integer i;
    for (i=0;i<=steps;i++) 
    {
        llSetPos(llGetPos() + offset * i);
    }
}

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
    
    state_entry() {
        // Hover text to help users understand that the object can be interacted with.
        llSetText("Trivia Terminal!", blue, opaque);
    }
    
    touch_start(integer totalNumber) {   
        // Kill off current listeners
        llListenRemove(gListener);
        
        // Get user UUID & setup listener
        user = llDetectedKey(0);
        gListener = llListen(-99, "", user, "");
        
        promptText("What is the definition of the privacy value?", "foo");
    }
    
    listen(integer chan, string name, key id, string msg) {

        if (msg == currentAnswer) {        
            dialog("Nice job! Welcome in, move quick!", close);
            move(currentOffset);          
            up = TRUE;
            llSetTimerEvent(5);
        } else {
            dialog("Incorrect answer! Try again.", close);
        }   
        
        llListenRemove(gListener); 
    }
    
    timer() {
        llListenRemove(gListener);
        if (up) {
            move(-1 * currentOffset);
            up = FALSE;
        }   
    }
    
}
