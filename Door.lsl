integer UP;
vector currentOffset = <0,0,0.2>;
integer steps = 20;

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
        //llListen(99,"",llGetOwner(),"");
        //UP = FALSE;
    }
   
    on_rez(integer start_param)
    {
        llResetScript(); // Always start with a clean slate
    }
   
   
    listen(integer channel, string name, key id, string message)
    {
        // This is a panic abort.  If object takes off, type "/99  " and SHOUT it.  It'll return.
       // llResetScript();
    }

    touch_start(integer total_number)
    {
        currentOffset = currentOffset * -1; 
        move(currentOffset);
    }
   


}
