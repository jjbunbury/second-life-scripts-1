/*v### Scavenger Object Settings - Make Changes Below ###v*/
string TOKEN_NAME = "Privacy"; //VSD Value (Pick valid value from VSD_LIST below if this is not a decoy)
string TRIGGER_ID = "Privacy Token Dispenser"; //Object name - Make sure this matches with the trigger plate/button settings in scavenger_trigger_button.lsl or scavenger_trigger_plate.lsl, meaningful name preferred
integer ALWAYS_VISIBLE = TRUE; //FALSE if there is another object that triggers this object to appear
integer ACTIVATION_TIME = 30;  //Time until object disappears (seconds) after being activated (make sure ALWAYS_VISIBLE = FALSE and this matches with the object settings)
float DEACTIVATED_ALPHA = 0.2; //1.0 for fully opaque, 0.0 for fully transparent 
integer SHOW_COUNTDOWN = FALSE; //Show floating text countdown
vector COUNTDOWN_COLOR = <1.0, 1.0, 1.0>;
integer ENABLE_PING = FALSE; //Allow object to be ping by HUD
/*^### Scavenger Object Settings - Make Changes Above ###^*/

/*Global Constants*/
string SEPERATOR = "|||";
integer SCAVENGER_HUD_CHANNEL = -498; 
integer SCAVENGER_OBJECT_CHANNEL = 498;
string XOR_KEY = "husky498uw!";
list VSD_LIST = 
    ["Accountability", "Autonomy", "Calmness", "Courtesy",
    "Educational", "Empirical", "Environmental Stability", "Freedom from Bias",
    "Human Welfare", "Identity", "Informed Consent", "Ownership/Property",
    "Trust", "Universal Usability", "Exceptional", "Privacy"];
    
/*Index Constants for Incoming Parameters*/
integer TIME_STAMP = 0;
integer ID = 1;
integer COMMAND = 2;
integer PARAMETER = 3;

/*Global Variables*/
integer listenHandle = 0;
integer timerCounter = 1;

/*Encode & Decode Functions (for security)*/
string Xor(string data, string xorKey)
{
     return llXorBase64(llStringToBase64(data), llStringToBase64(xorKey));
}
 
string Dexor(string data, string xorKey) 
{
     return llBase64ToString(llXorBase64(data, llStringToBase64(xorKey)));
}

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
//vector currentOffset = <.2,0,0>;
//integer steps = 8;
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
 
default {
    
    on_rez(integer p) { llResetScript(); }
    
    state_entry() {
        // Hover text to help users understand that the object can be interacted with.
        llSetText("Privacy Token Computer!", blue, opaque);
        
    }
    
    touch_start(integer totalNumber) {   
        // Kill off current listeners
        llListenRemove(gListener);
        
        // Get user UUID & setup listener
        user = llDetectedKey(0);
        gListener = llListen(-99, "", user, "");
        
        promptText("Welcome! In order to find the thing, I am giving you permission to look around this room for three hidden objects. Touching these objects will pose trivia questions about privacy. Answering these will give you the answer to this terminal, unlocking the thing. What is the three letter answer?'", "vsd");
    }
    
    listen(integer chan, string name, key id, string msg) {
        msg = llToLower(msg);
        if (msg == currentAnswer) {        
            string timeStamp = llGetTimestamp();
            key avatarKey = id;
            string command = "ADD_TOKEN";
            string parameter = TOKEN_NAME;
            string xorParameterList = Xor(timeStamp + SEPERATOR + (string)avatarKey + SEPERATOR + command + SEPERATOR + parameter, XOR_KEY + (string)avatarKey);  
            llSay(SCAVENGER_HUD_CHANNEL, xorParameterList);

            dialog("Nice job! You have solved the riddle. Have a Privacy token!", close);
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
