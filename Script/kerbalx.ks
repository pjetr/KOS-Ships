CLEARSCREEN.
COUNT_DOWN.
LAUNCH.
COAST_TO_AP.
CIRCULARIZE.
ORBIT.

DECLARE FUNCTION COUNT_DOWN {
    CLEARSCREEN.
    PRINT ">  COUNTDOWN:".
    PRINT "==============".
    FROM { 
        LOCAL count is 10.
    } 
    UNTIL (count = 0) 
    STEP {
        SET count TO count - 1.
    } DO {
        PRINT "> T - " + count + "     " AT (0, 3).
    }
}
DECLARE FUNCTION LAUNCH {
    SET THROTTLE TO 1.
    SET targetDirection TO 90.
    LOCK targetPitch TO 88.963 - 1.03287 * ALT:RADAR ^ 0.409511.
    LOCK STEERING TO HEADING(targetDirection, targetPitch).

    UNTIL APOAPSIS > 100000 {
        PRINT_INFO.

        IF STAGE:LIQUIDFUEL < 0.1 {
            DO_STAGE.
        }
    }
}
DECLARE FUNCTION COAST_TO_AP {
    SET THROTTLE TO 0.
    LOCK STEERING TO PROGRADE.

    RCS ON.
    SAS ON.

    UNTIL ETA:APOAPSIS < 15 {
        IF ETA:APOAPSIS > 25 {
            SET WARP TO 4.
        } ELSE {
            SET WARP TO 1.
        }

        PRINT_INFO.
    }
}
DECLARE FUNCTION CIRCULARIZE {
    LOCK STEERING TO PROGRADE.

    WAIT 1.

    RCS OFF.
    SAS OFF.
    SET THROTTLE TO 1.

    UNTIL PERIAPSIS > 95000 {
        PRINT_INFO.
    }
}
DECLARE FUNCTION ORBIT {
    SET THROTTLE TO 0.
    SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.

    RCS OFF.
    SAS OFF.

    EXIT.
}

DECLARE FUNCTION DO_STAGE {
    STAGE.
}

DECLARE FUNCTION PRINT_INFO {
    PRINT ">  KERBALX++                                      " AT (0, 0).
    PRINT "> ===========                                     " AT (0, 1).
    PRINT "> APOAPSIS  : " + ROUND( APOAPSIS )  + "          " AT (0, 2).
    PRINT "> PERIAPSIS : " + ROUND( PERIAPSIS ) + "          " AT (0, 3).
}