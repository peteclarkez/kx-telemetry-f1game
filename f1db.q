// F1 In memory DB

// Port needs to match f1.q
\p 3030 

// There are 2 sources of data.
// The process can either listen to incoming data, or reload the data from one of the eventlogs


//
// @desc
// @param t {symbol} 
// @param p {timestamp} 
// @param d {dictionary } 
upd:{[t;p;d]
    //0N!(t;p;(t like "PacketMotionData"));
    //:(::);

    // Added to handle old log files, maybe removed later.
    if[-11h <> type t;
        t:`$t;
    ];
    $[t like "PacketMotionData";
        data:insertPacketMotionData[t;.z.p;d];
        data:(::)
    ];

    //:(::);

    if[98h = type data;
        t insert data
    ];
 };


// @example replaydata[hsym `$"F12018-2019.04.03.tplog"]
replaydata:{[logfile]
    recordCount:-11!(-2;logfile);    
    0N!"Replaying data ",(string recordCount)," Records";
    -11!(-1;logfile);
 };

// TODO : this has been adapted from the packetdataloader.
// Should be updated to refect individual messages coming in. 
// TODO Should include a col for pno.
insertPacketMotionData:{[t;p;d]
    //0N!(t;p);    

   raze {[p;d;pno]  
        motioncols:`m_suspensionPosition`m_suspensionVelocity`m_suspensionAcceleration`m_wheelSpeed`m_wheelSlip`m_localVelocityX`m_localVelocityY`m_localVelocityZ`m_angularVelocityX`m_angularVelocityY`m_angularVelocityZ`m_angularAccelerationX`m_angularAccelerationY`m_angularAccelerationZ`m_frontWheelsAngle;
        m:flip (key md)!enlist each value md:`time xcols update time:p from (d[`cars_motion_data])[pno];
        m2:([]time:enlist p)!flip motioncols!enlist each @[d;motioncols];
        h:([]time:enlist p)!flip (key h)!enlist each value h:d`header;
        (m lj m2) lj h
    }[p;d] each til 20 // All Motion Values have 20 elements // TODO Maybe able to only insert populated rows
 };