# Kx Telemetry for F1 2018 Video Game

## Processes

To run this it is necessary to start 2 processes.


```
q f1db.q
q f1.q
```

`f1db.q` will open a port on 3030 and start to listen for data coming in from the f1 process.
It is also possible to replay an event log directly into memory using `replaydata`

`f1.q` will load the necessary python code and start listening for data. It may be necessary to change the UDP_HOST to the IP address of the machine running it. The process will also save an eventlog to disk which may be replayed at a later data.


## Acknowledgements

The Python code used to read the F1 2018 Data is based on the code from Simon Dubois found inside this repository.

https://github.com/simasimsd/F1-telemetry-2018