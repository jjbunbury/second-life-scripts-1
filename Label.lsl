// Cody Stebbins
// MIT License
// Contact mail@codystebbins.com for help!

// General
vector blue = <0.000, 0.455, 0.851>;
float opaque = 1.0;
 
default {
    
    on_rez(integer p) { llResetScript(); }
    
    state_entry() {
        // Hover text to help users understand that the object can be interacted with.
        llSetText("Privacy Token Computer!", blue, opaque);   
    }
    
}
