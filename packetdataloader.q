// Initial Version of code to read in data from the eventlog
// This works by loading the eventlog directly and then parsing all the data from it

// TODO this should be updated to replay the event log and convert the data at that point.
// this should be completed in f1db so that the code for real time and code for loading event logs is the same.
//
loaddata:{[eventlog]
    f1data:get eventlog;
 };

getSummary:{[x]
    (key y)!count each value y:group `$x[;1]
 };

getParticipantData:{[x]
    d:x[;2 3] where x[;1] like "PacketParticipantsData";
    dd:d[;0]!{update m_name:{`$`char$x} each m_name from (update pno:i from x) where 1< count each m_name} each d[;1]`participants_data;    
    pp:raze {[t;d] `time`m_name xcols update time:t from d}'[(key dd);(value dd)];
    h:([]time:d[;0])!d[;1]`header;
    pp lj h
 };


getMotion:{[x;pno]
    
    motioncols:`m_suspensionPosition`m_suspensionVelocity`m_suspensionAcceleration`m_wheelSpeed`m_wheelSlip`m_localVelocityX`m_localVelocityY`m_localVelocityZ`m_angularVelocityX`m_angularVelocityY`m_angularVelocityZ`m_angularAccelerationX`m_angularAccelerationY`m_angularAccelerationZ`m_frontWheelsAngle;
    d:x[;2 3] where x[;1] like "PacketMotionData";
    m:`time xcols update time:d[;0] from (d[;1]`cars_motion_data)[;pno];
    m2:([]time:d[;0])!flip motioncols!d[;1]motioncols;
    h:([]time:d[;0])!d[;1]`header;
    
    (m lj m2) lj h
 };

getTelemetry:{[x;pno]
    d:(x[;2 3] where x[;1] like "PacketCarTelemetryData");
    h:([]time:d[;0])!d[;1]`header;
    t:`time xcols update time:d[;0] from (d[;1]`cars_telemetry_data)[;pno];
    (update m_buttonStatus:d[;1]`m_buttonStatus from t) lj h    
 };

getLapData:{[x;pno]
    d:(x[;2 3] where x[;1] like "PacketLapData");
    h:([]time:d[;0])!d[;1]`header;    
    l:`time xcols update time:d[;0] from (d[;1]`laps_data)[;pno];
    l lj h
 };

getStatus:{[x;pno]
    d:(x[;2 3] where x[;1] like "PacketCarStatusData");
    //h:([]time:d[;0])!d[;1]`header;
    s:`time xcols update time:d[;0] from (d[;1]`cars_status_data)[;pno];
    :s;
 };

getSession:{[x]
    sessioncols:`m_weather`m_airTemperature`m_totalLaps`m_trackLength`m_sessionType`m_trackId`m_era`m_sessionTimeLeft`m_sessionDuration`m_pitSpeedLimit`m_gamePaused`m_isSpectating`m_spectatorCarIndex`m_sliProNativeSupport`m_safetyCarStatus`m_networkGame;
    marshalcols:`m_numMarshalZones`m_marshalZones;
    d:(x[;2 3] where x[;1] like "PacketSessionData");
    h:([]time:d[;0])!d[;1]`header;     
    s:([]time:d[;0])!flip sessioncols!d[;1]sessioncols;
    s lj h
 };

getCarSetup:{[x;pno]
     
    d:(x[;2 3] where x[;1] like "PacketCarSetupData");
    h:([]time:d[;0])!d[;1]`header; 
    
    s:`time xcols update time:d[;0] from (d[;1]`cars_setup_data)[;pno];
    (update m_numCars:d[;1]`m_numCars from s) lj h

 };

getEvent:{[x]
    ecols:enlist `m_eventStringCode;
    d:(x[;2 3] where x[;1] like "PacketEventData");    
    h:([]time:d[;0])!d[;1]`header;     
    e:([]time:d[;0])!flip ecols!{`$`char$x}d[;1]ecols;
    e lj h
 };



f1data:loaddata[hsym `$"F12018-2019.04.03.tplog"]

getSummary[f1data]
getParticipantData[f1data]
getStatus[f1data;0]
getLapData[f1data;0]
1000_getTelemetry[f1data;0]
1000_getMotion[f1data;0]
getSession[f1data]
getCarSetup[f1data;0]
getEvent[f1data]