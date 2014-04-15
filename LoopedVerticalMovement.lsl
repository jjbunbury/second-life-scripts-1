vector startPos;
integer ON;
vector offset = <0,0,0.5>;
integer steps = 50;
 
default
{
state_entry()
{
startPos = llGetPos(); // Figure out where Object is to start
llListen(99,"",llGetOwner(),"");
ON = FALSE;
}
on_rez(integer start_param)
{
llResetScript(); // Always start with a clean slate
}
listen(integer channel, string name, key id, string message)
{
// This is a panic abort. If object takes off, type "/99 " and SHOUT it. It'll return.
llSetPos(startPos);
llResetScript();
}
 
touch_start(integer total_number)
{
ON = !ON;
if (ON)
{
llSetTimerEvent(1); // Activate timer every 30 seconds. This means object will be DOWN most of the time.
}
else
{
llSetTimerEvent(0); //Stop the timer
}
}
timer()
{
integer i;
for (i=0;i<=steps;i++) // Rise in 20 steps of 0.5m each = 10m, starting at startPos.
//Starting the rise each time at startPos guarantees that the object will always start at its base position
// with each timer cycle.
{
llSetPos(startPos + offset * i);
}
for (i=0;i<=steps;i++) // Go back down in 20 steps of 0.5m each.
{
llSetPos(llGetPos() - offset * i);
}
}
 
}
