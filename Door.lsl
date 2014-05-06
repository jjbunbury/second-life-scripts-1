// Cody Stebbins
// MIT License
// Contact mail@codystebbins.com for help!

vector currentOffset = <0,0,0.2>;
integer steps = 8;
vector blue = <0.000, 0.455, 0.851>;
float  opaque = 1.0;

integer move(vector offset)
{
    integer i;
    for (i=0;i<=steps;i++) 
    {
        llSetPos(llGetPos() + offset * i);
    }
    return 0;
}
 

default
{
    state_entry()
    { 
        llSetText("Door! Touch me to open!", blue, opaque);
    }
   
    on_rez(integer start_param)
    {
        llResetScript(); // Always start with a clean slate
    }

    touch_start(integer total_number)
    {
        currentOffset = currentOffset * -1; 
        move(currentOffset);
    }
}
