// When the prim is touched, give the toucher the option of killing the prim.
 
integer gListener;     // Identity of the listener associated with the dialog, so we can clean up when not needed
key user;
 
default
{
    touch_start(integer total_number)
    {
        // Kill off any outstanding listener, to avoid any chance of multiple listeners being active
        llListenRemove(gListener);
        // get the UUID of the person touching this prim
        user = llDetectedKey(0);
        // Listen to any reply from that user only, and only on the same channel to be used by llDialog
        // It's best to set up the listener before issuing the dialog
        gListener = llListen(-99, "", user, "");
        // Send a dialog to that person. We'll use a fixed negative channel number for simplicity
        llDialog(user, "\nAre you a fan of virtual worlds?", ["Yes", "No" ] , -99);
        // Start a one-minute timer, after which we will stop listening for responses
        llSetTimerEvent(60.0);
    }
    listen(integer chan, string name, key id, string msg)
    {
            llListenRemove(gListener);
        // If the user clicked the "Yes" button, kill this prim.
        if (msg == "No") {
            llDialog(user, "\nShameful!", ["Shameful!" ] , -99);
        } else if (msg == "Yes") {
            llDialog(user, "\nGreat, welcome to ISchool!", ["Close" ] , -99);
        }
            
        // The user did not click "Yes" ...
        // Make the timer fire immediately, to do clean-up actions
        llSetTimerEvent(0.1);        
    }
    timer()
    {
        // Stop listening. It's wise to do this to reduce lag
        llListenRemove(gListener);
        // Stop the timer now that its job is donewd
        llSetTimerEvent(0.0);// you can use 0 as well to save memory
    }
}
