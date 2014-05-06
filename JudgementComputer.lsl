// Cody Stebbins
// MIT License
// Contact mail@codystebbins.com for help!

vector blue = <0.000, 0.455, 0.851>;
float opaque = 1.0;
integer gListener; // Listener for current dialog
key user; // UUID of current user
list close = ["Close"]; // Close options

dialog(string message, list options) {
    // Send a dialog to that person on the -99 channel.
    llDialog(user, message, options, -99);
    // Start a one-minute timer, after which we will stop listening for responses
    llSetTimerEvent(60);  
} 
 
default
{
    
    on_rez(integer start_param)
    {
        // Always start with a clean slate
        llResetScript(); 
    }
    
    state_entry()
    {
        // Hover text to help users understand that the object can be interacted with.
        llSetText("Judgement Computer! Touch me to have a conversation.", blue, opaque);
    }
    
    touch_start(integer total_number)
    {
        // Kill off current listeners
        llListenRemove(gListener);
        
        // Get user UUID & setup listener
        user = llDetectedKey(0);
        gListener = llListen(-99, "", user, "");
        
        dialog("\nAre you a fan of virtual worlds?", ["Yes", "No" ]);
    }
    
    listen(integer chan, string name, key id, string msg)
    {
        llListenRemove(gListener);

        if (msg == "No") {
            dialog("\nHow sad! Do you not like immersion?!", close);
        } else if (msg == "Yes") {
            dialog("\nGreat, welcome to iSchool!", close);
        }
        
        // Make the timer fire immediately, to do clean-up actions
        //llSetTimerEvent(0.1);        
    }
    
    timer()
    {
        // Stop listening & stop timer if the user does not respond before time limit
        llListenRemove(gListener);
        llSetTimerEvent(0);
    }
    
}
