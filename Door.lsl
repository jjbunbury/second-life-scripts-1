// Cody Stebbins
// MIT License
// Contact mail@codystebbins.com for help!

// General
vector blue = <0.000, 0.455, 0.851>;
float opaque = 1.0;
key user; // UUID of current user
integer doorSwitchChannel = 3900;

// Trivia
integer gListener; // Listener for current dialog
string currentAnswer;
list close = ["Close"]; // Close options

// Movement
integer up = FALSE;

move(float direction)
{
    integer i;
    llSetRot(llEuler2Rot(<0, 0, direction * PI_BY_TWO>) * llGetRot());
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

openDoor() {
    move(1);          
    up = TRUE;
    llSetTimerEvent(5);
}
 
default {
    
    on_rez(integer p) { llResetScript(); }
    
    state_entry() {}
    
    touch_start(integer totalNumber) {    
        // Check if the face is inside the house, 
        // and open the door without trivia to avoid annoying guests.
        integer face = llDetectedTouchFace(0);
        if (face == 2)
        {
            openDoor();
            return;
        }

        // Kill off current listeners
        llListenRemove(gListener);
        
        // Get user UUID & setup listener
        user = llDetectedKey(0);
        gListener = llListen(-99, "", user, "");
        
        promptText("Fill in the blank! '_______ refers to a claim, an entitlement, or a right of an individual to determine what information about himself or herself can be communicated to others'", "privacy");
    }
    
    listen(integer chan, string name, key id, string msg) {
        msg = llToLower(msg);
        if (msg == currentAnswer) {        
            dialog("Nice job! Welcome in, move quick!", close);
            openDoor();
        } else {
            dialog("Incorrect answer! Try again.", close);
        }   
        
        llListenRemove(gListener); 
    }
    
    timer() {
        llListenRemove(gListener);
        if (up) {
            move(-1);
            up = FALSE;
        }   
    }
    
}
