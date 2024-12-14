// Principia node maneur executor.

function work {
    if(allNodes:length = 0) {
        print "No nodes to execute".
        return.
    }
    

    set currentNode to allNodes[0].
    
    set currentStageDeltaV to stage:deltav:current.
    set requiredBurnDelta to currentNode:deltav:mag.


    if (requiredBurnDelta > currentStageDeltaV) {
        print "Not enough deltaV at current stage".
        // todo: add stage change.
        return.
    }


    lock burnTime to requiredBurnDelta / ship:availablethrust * ship:mass.
    lock nodeETA to eta:nextnode.
    lock burnETA to nodeETA - burnTime / 2.

    lock steering to currentNode.
    lock rotationError TO VANG(currentNode:deltav, SHIP:FACING:VECTOR).

    until rotationError < 0.05 {
        clearScreen.
        print "Invalid angle, rotating...".
        print "Rotation error: " + floor(rotationError) + "°".
    }
    unlock rotationError.

    until burnETA < 0 {
        clearScreen.
        // TODO: start && stop time acceleration.

        print "Time left: " + floor(burnETA) + "s".
        print "Burn time: " + floor(burnTime) + "s".
        print "Required deltaV to burn: " + floor(requiredBurnDelta) + "m/s".
    }

    set reqDir to currentNode:deltav:normalized.
    set currentDir to ship:velocity:orbit:normalized.

    lock direction to VDOT(reqDir, currentDir).
    

    lock currentOrbitalVelocity to SHIP:VELOCITY:ORBIT:MAG.
    set requiredDeltaV to direction * currentNode:deltav:mag.
    set targetVelocity to currentOrbitalVelocity + requiredDeltaV. 

    lock velocityError to targetVelocity - currentOrbitalVelocity.

    lock throttle to 1.
    wait until abs(velocityError) < 1.

    unlock velocityError.
    unlock deltaProSec.
    unlock throttle.

    print "Node executed".

}

clearScreen.

work.