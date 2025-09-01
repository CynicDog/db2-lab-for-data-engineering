# Performance and Monitoring

This section outlines key concepts and practical methods for monitoring the performance of a DB2 database, with a focus on ETL workloads. This includes understanding the various types of logs DB2 generates and how to configure them for modern log aggregation platforms.

### 1\. DB2 Log Types and Locations

In your DB2 container environment, you can directly interact with the logs to understand their purpose and format. Let's look at the key logs you'll encounter and how to access them.

#### 1.1. Diagnostic Log (`db2diag.log`)

The diagnostic log is the primary source for troubleshooting. You'll find it in a member-specific subdirectory of your instance's diagnostic path.

**Location**: Use the `db2 get dbm cfg` command to find the `DIAGPATH`. However, the log file itself is located in the `Current member resolved DIAGPATH`, which in your case is `/database/config/db2inst1/sqllib/db2dump/DIAG0000/`.

```bash
# Verify the resolved DIAGPATH
db2 get dbm cfg | grep DIAGPATH

# Navigate to the resolved path and list its contents
cd /database/config/db2inst1/sqllib/db2dump/DIAG0000/
ls -l

# View the log file, which is named db2diag.log
tail -f db2diag.log
```

<details><summary>Examples</summary>

```
2025-09-01-04.01.42.935663+000 I465616E393           LEVEL: Warning
PID     : 20648                TID : 140736993265536 PROC : db2star2
INSTANCE: db2inst1             NODE : 000
HOSTNAME: 2e62336d93c9
FUNCTION: DB2 UDB, base sys utilities, sqleReleaseStStLockFile, probe:16242
MESSAGE : Released lock on the file:
DATA #1 : String, 50 bytes
/database/config/db2inst1/sqllib/ctrl/db2stst.0000

2025-09-01-04.01.42.954483+000 I466010E1182          LEVEL: Event
PID     : 20646                TID : 140736993265536 PROC : db2start
INSTANCE: db2inst1             NODE : 000
HOSTNAME: 2e62336d93c9
FUNCTION: DB2 UDB, base sys utilities, sqlePrintFinalMessage, probe:13803
DATA #1 : unsigned integer, 4 bytes
0
DATA #2 : signed integer, 4 bytes
1
DATA #3 : SQLCA, PD_DB2_TYPE_SQLCA, 136 bytes
 sqlcaid : SQLCA     sqlcabc: 136   sqlcode: 0   sqlerrml: 0
 sqlerrmc: 
 sqlerrp : SQL11058
 sqlerrd : (1) 0x00000000      (2) 0x00000000      (3) 0x00000000
           (4) 0x00000000      (5) 0x00000000      (6) 0x00000000
 sqlwarn : (1)      (2)      (3)      (4)        (5)       (6)    
           (7)      (8)      (9)      (10)        (11)     
 sqlstate:      
DATA #4 : SQLCA, PD_DB2_TYPE_SQLCA, 136 bytes
 sqlcaid : SQLCA     sqlcabc: 136   sqlcode: -1063   sqlerrml: 0
 sqlerrmc: 
 sqlerrp : SQLESSSN
 sqlerrd : (1) 0x00000000      (2) 0x00000000      (3) 0x00000000
           (4) 0x00000000      (5) 0x00000000      (6) 0x00000000
 sqlwarn : (1)      (2)      (3)      (4)        (5)       (6)    
           (7)      (8)      (9)      (10)        (11)     
 sqlstate:      

2025-09-01-04.01.42.959247+000 I467193E1270          LEVEL: Event
PID     : 20646                TID : 140736993265536 PROC : db2start
INSTANCE: db2inst1             NODE : 000
HOSTNAME: 2e62336d93c9
FUNCTION: DB2 UDB, base sys utilities, sqleIssueStartStop, probe:12187
DATA #1 : SQLCA, PD_DB2_TYPE_SQLCA, 136 bytes
 sqlcaid : SQLCA     sqlcabc: 136   sqlcode: 0   sqlerrml: 0
 sqlerrmc: 
 sqlerrp : SQL11058
 sqlerrd : (1) 0x00000000      (2) 0x00000000      (3) 0x00000000
           (4) 0x00000000      (5) 0x00000000      (6) 0x00000000
 sqlwarn : (1)      (2)      (3)      (4)        (5)       (6)    
           (7)      (8)      (9)      (10)        (11)     
 sqlstate:      
DATA #2 : SQLCA, PD_DB2_TYPE_SQLCA, 136 bytes
 sqlcaid : SQLCA     sqlcabc: 136   sqlcode: -1063   sqlerrml: 0
 sqlerrmc: 
 sqlerrp : SQLEPFIN
 sqlerrd : (1) 0x00000000      (2) 0x00000000      (3) 0x00000000
           (4) 0x00000000      (5) 0x00000000      (6) 0x00000000
 sqlwarn : (1)      (2)      (3)      (4)        (5)       (6)    
           (7)      (8)      (9)      (10)        (11)     
 sqlstate:      
DATA #3 : Boolean, 1 bytes
false
DATA #4 : Boolean, 1 bytes
false
DATA #5 : Boolean, 1 bytes
false
DATA #6 : Boolean, 1 bytes
false
DATA #7 : Boolean, 1 bytes
false

2025-09-01-04.01.42.961354+000 I468464E393           LEVEL: Warning
PID     : 20646                TID : 140736993265536 PROC : db2start
INSTANCE: db2inst1             NODE : 000
HOSTNAME: 2e62336d93c9
FUNCTION: DB2 UDB, base sys utilities, sqleReleaseStStLockFile, probe:16242
MESSAGE : Released lock on the file:
DATA #1 : String, 50 bytes
/database/config/db2inst1/sqllib/ctrl/db2strst.lck

2025-09-01-04.03.37.960445+000 I468858E460           LEVEL: Error
PID     : 19112                TID : 140737381652352 PROC : db2bp
INSTANCE: db2inst1             NODE : 000            DB   : SAMPLE  
APPID   : *LOCAL.db2inst1.250901040046
HOSTNAME: 2e62336d93c9
FUNCTION: DB2 UDB, base sys utilities, sqleriar_database, probe:9
RETCODE : ZRC=0x8005006D=-2147155859=SQLE_CA_BUILT
          "SQLCA has been built and saved in component specific control block."
```

</details>

The output of the `tail` command will show a series of log entries, each starting with a standardized header that includes a timestamp, PID, and other key identifiers. This is the log file you would configure your log forwarding agent (e.g., Fluent Bit, Logstash) to monitor.

### 1.2. Transaction Logs (Recovery Logs)

These logs are essential for data durability and recovery and are not human-readable. They are stored in a separate directory defined by the **`LOGPATH`** database configuration parameter.

The default `LOGPATH` is not explicitly set in the database configuration, so we must manually navigate the directory structure. In your case, the logs are in the `LOGSTREAM0000` subdirectory.

```bash
# Navigate to the database home directory
cd /database/data/db2inst1/NODE0000/SQL00001/

# The ls -l command confirms the existence of the log directory
ls -l

# Navigate into the log directory
cd LOGSTREAM0000/

# List the contents; you will find files with a .LOG extension
ls -l
```

The files you see, like `S0000001.LOG`, follow a naming convention of `S` followed by a seven-digit sequence number and a `.LOG` extension. This number is how DB2 keeps track of the log file order. The contents of these files are proprietary binary data, as a simple `cat` command shows. You can't directly forward them to a log aggregation platform.

#### Using `db2fmtlog` to Read a Transaction Log

The `db2fmtlog` utility converts binary transaction log files into a human-readable text format. This is crucial for an ETL administrator to understand what data changes are being written to disk for forensic analysis and troubleshooting.

**Formatting a Single Log File**:

To format a single log file, specify its sequence number. Since the `-o` option is not supported in your DB2 version, we'll use shell redirection (`>`) to save the output to a file. For example, to format `S0000001.LOG`, you would use the number `1`.

```bash
# In the LOGSTREAM0000 directory, format S0000001.LOG and save the output
db2fmtlog 1 > /tmp/S0000001_formatted.log

# View the formatted log file
cat /tmp/S0000001_formatted.log
```

<details><summary>Examples</summary>

```
[db2inst1@2e62336d93c9 LOGSTREAM0000]$ db2 "update EMPLOYEE set SALARY = 100000 where EMPNO = '000010';"
DB20000I  The SQL command completed successfully.
[db2inst1@2e62336d93c9 LOGSTREAM0000]$ ls
S0000001.LOG  S0000003.LOG  S0000005.LOG  S0000007.LOG	S0000009.LOG  S0000011.LOG  S0000013.LOG  S0000015.LOG
S0000002.LOG  S0000004.LOG  S0000006.LOG  S0000008.LOG	S0000010.LOG  S0000012.LOG  S0000014.LOG  S0000016.LOG
[db2inst1@2e62336d93c9 LOGSTREAM0000]$ db2fmtlog 1 > /tmp/S0000001_formatted.log
[db2inst1@2e62336d93c9 LOGSTREAM0000]$ cat /tmp/S0000001_formatted.log 
Log File S0000001.LOG:
   Extent Number              1
   Format Version             14
   Architecture Level Version V:11 R:5 M:8 F:0 I:0 SB:0
   Encrypted                  No
   Compression Mode           OFF
   Number of Pages            1024
   Partition                  0
   Log Stream                 0
   Database Seed              3787043160
   Log File Chain ID          0
   Previous Extent ID         2025-09-01-04.00.16.000000 GMT
   Current Extent ID          2025-09-01-04.00.45.000000 GMT
   Database log ID            2025-09-01-03.59.34.000000 GMT
   Topology Life ID           2025-09-01-03.59.34.000000 GMT
   First LFS/LSN              5283/0000000000047ABD
   Last LFS/LSN               Unset
   LSO range                  52988001 to 57161824
|------|------------------------------------------------------------------------
| PAGE | Page number: 0
|      |                     Byte count = 203
|      |                    First index = 0
|      |              Page header flags = 0x0010
|      |                                  - SQLPG_PHF_END_OF_FLUSH
|      |                       Page lso = 52988203
|------|------------------------------------------------------------------------
| LREC |  5283  00047ABD  00000000016D  N:DMS:FULLB4_DELTA_UPD  2:6     
|------|------------------------------------------------------------------------
| LREC |                     Record LSO = 52988001
|      |                            LFS = 5283
|      |                            LSN = 0000000000047ABD
|      |                    Record Size = 0x0000009B = 155
|      |                    Record Type = 0x4E = Normal
|      |               Log Header Flags = 0x0000
|      |                     Record TID = 00000000016D
|      |               Back Pointer LSO = 0
|      |                Originator Code = 0x01 = Data File Manager
|      |                    Function ID = 0xBE = 190 : SQLD_FULLBEFORE_DELTA_UPD
|      |                         PoolID = 2 ObjectID = 6
|------|------------------------------------------------------------------------
| LREC |  5283  00047ABE  00000000016D  Commit SE                         2025-09-01-04.28.30 GMT
|------|------------------------------------------------------------------------
| LREC |                     Record LSO = 52988156
|      |                            LFS = 5283
|      |                            LSN = 0000000000047ABE
|      |                    Record Size = 0x00000030 = 48
|      |                    Record Type = 0x84 = Commit SE
|      |               Log Header Flags = 0x2000
|      |                     Record TID = 00000000016D
|      |               Back Pointer LSO = 52988001
|      |                     Time Stamp = 0x68B520EE = 1756700910 = 2025-09-01-04.28.30 GMT
|      |                    Nanoseconds = 1
[db2inst1@2e62336d93c9 LOGSTREAM0000]$ db2fmtlog 16 > /tmp/S00000016_formatted.log
```

</details>

**Understanding the Formatted Output**:

The `db2fmtlog` output is composed of a header followed by individual log records. The header, which is what you've seen so far, provides metadata about the log file. 

Here's a breakdown of the key header fields and how they relate to your work as an ETL administrator:

  * **Extent Number**: This is the log file's sequence number, corresponding to the number in the filename (e.g., Extent Number 1 is for `S0000001.LOG`).
  * **Current Extent ID**: The timestamp when the log file was closed. This marks the chronological point when DB2 started writing to a new log file.
  * **LSO range**: The **Log Sequence Offset** range. This is a unique identifier within the log stream that allows DB2 to pinpoint a specific log record.

The reason you might see transaction data in an "older" file like `S0000001.LOG` is due to **circular logging**, DB2's default logging method. The database pre-allocates a set number of logs and overwrites them in a continuous loop. This means the file that contains your most recent transactions may not be the one with the highest sequence number. This is why you must identify the **active log file** using `db2pd -logs` to see the latest changes.

<details><summary>Examples</summary>

```
[db2inst1@2e62336d93c9 LOGSTREAM0000]$ db2pd -logs -db SAMPLE

Database Member 0 -- Database SAMPLE -- Active -- Up 0 days 00:05:08 -- Date 2025-09-01-04.33.33.910169

Logs:
Current Log Number            1         
Pages Written                 71        
Cur Commit Disk Log Reads     0                   
Cur Commit Total Log Reads    0                   
Method 1 Archive Status       n/a
Method 1 Next Log to Archive  1         
Method 1 First Failure        n/a
Method 2 Archive Status       n/a
Method 2 Next Log to Archive  n/a
Method 2 First Failure        n/a
Extraction Status             n/a (0)
Extraction Throttle Reason    n/a
Current Log to Extract        n/a
Log Chain ID                  0         
Current LSO                   53279365            
Current LSN                   0x000000000004809A

Address            StartLSN         StartLSO             State      Size       Pages      Filename
0x00007FFF771FF630 0000000000047ABD 52988001             0x00000000 1024       1024       S0000001.LOG
0x00007FFF772007D0 0000000000000000 57161825             0x00000000 1024       1024       S0000002.LOG
0x00007FFF77201130 0000000000000000 61335649             0x00000000 1024       1024       S0000003.LOG
0x00007FFF77201A90 0000000000000000 65509473             0x00000000 1024       1024       S0000004.LOG
0x00007FFF772023F0 0000000000000000 69683297             0x00000000 1024       1024       S0000005.LOG
0x00007FFF77202D50 0000000000000000 73857121             0x00000000 1024       1024       S0000006.LOG
0x00007FFF772036B0 0000000000000000 78030945             0x00000000 1024       1024       S0000007.LOG
0x00007FFF77204010 0000000000000000 82204769             0x00000000 1024       1024       S0000008.LOG
0x00007FFF77204970 0000000000000000 86378593             0x00000000 1024       1024       S0000009.LOG
0x00007FFF772052D0 0000000000000000 90552417             0x00000000 1024       1024       S0000010.LOG
0x00007FFF77205C30 0000000000000000 94726241             0x00000000 1024       1024       S0000011.LOG
0x00007FFF77206590 0000000000000000 98900065             0x00000000 1024       1024       S0000012.LOG
0x00007FFF77206EF0 0000000000000000 103073889            0x00000000 1024       1024       S0000013.LOG
0x00007FFF77207850 0000000000000000 107247713            0x00000000 1024       1024       S0000014.LOG
0x00007FFF772081B0 0000000000000000 111421537            0x00000000 1024       1024       S0000015.LOG
0x00007FFF77208B10 0000000000000000 115595361            0x00000000 1024       1024       S0000016.LOG
```
> * `Current Log Number`:	The value 1 means S0000001.LOG is the active log file. This confirms the circular logging behavior, where DB2 has wrapped around from S0000016.LOG back to the first log file to write new transactions.
> * `Pages Written`: The value 71 indicates that 71 log pages have been written to the current log file (S0000001.LOG). This is a direct measure of log activity and is useful for monitoring the rate at which the log is filling up.
> * `Current LSO`: The value 53279365 represents the current offset within the log stream. This is a crucial metric for data replication and change data capture (CDC) tools, which use LSOs to track their position and ensure no data changes are missed.
> * `Current LSN`: The value 0x000000000004809A is a hexadecimal identifier for the specific log record that the database is currently writing. This is used internally by DB2 to manage recovery and consistency.
> * `Filename`: The list of filenames from S0000001.LOG to S0000016.LOG confirms the pre-allocation of log files, which is a characteristic of circular logging. The fact that the StartLSN is populated for S0000001.LOG but not for the others means it's the first log in the current active log chain.

</details>

### 1.3. Audit Logs

Audit logs are not enabled by default and, like transaction logs, are stored in a proprietary binary format. The absence of files in the `/database/config/db2inst1/sqllib/security/auditdata/` directory confirms that auditing has not been activated.

To use auditing, you must first enable it and configure which audit events you want to track. The audit configuration is specific to the database instance.

Here are the commands and their explanations to configure and use audit logs.

#### Step 1: Configure Auditing

To start auditing, use the `db2audit configure` command to set auditing on and specify the event categories you want to capture.

```bash
[db2inst1@2e62336d93c9 ~]$ mkdir auditlogs
[db2inst1@2e62336d93c9 ~]$ mkdir archive
[db2inst1@2e62336d93c9 ~]$ db2audit configure datapath /database/config/db2inst1/auditlogs archivepath /database/config/db2inst1/archive
```

This command enables the auditing feature. However, you haven't specified which events to capture yet.

Now, set the specific audit events for the database instance. 

```bash
[db2inst1@2e62336d93c9 ~]$ db2 "CREATE AUDIT POLICY LOGALL CATEGORIES ALL STATUS BOTH ERROR TYPE AUDIT"
[db2inst1@2e62336d93c9 ~]$ db2 "AUDIT DATABASE USING POLICY LOGALL"
```

This command configures the database instance to log a wide range of activities. The log files will be written to the default `auditlogs` directory.

#### Step 2: Generate Audit Events

To see an audit log entry, you need to perform an action that triggers one of the configured events. Connect to the database and run an SQL query.

```bash
db2 connect to sample

   Database Connection Information

 Database server        = DB2/LINUXX8664 11.5.8.0
 SQL authorization ID   = DB2INST1
 Local database alias   = SAMPLE

db2 "select * from staff fetch first 1 rows only"
```

The `connect` and `select` commands generate `AUDIT` events that will be captured in the binary log files.

#### Step 3: Archive and View the Audit Log

As these logs are generated, you should periodically archive the logs so that they can be extracted downstream for further analysis. This also helps to keep the active log files of manageable size.

```bash
[db2inst1@2e62336d93c9 ~]$ ls auditlogs/
db2audit.db.SAMPLE.log.0

[db2inst1@2e62336d93c9 ~]$ db2 "CALL SYSPROC.AUDIT_ARCHIVE(NULL, NULL)"
[db2inst1@2e62336d93c9 ~]$ ls archive
db2audit.db.SAMPLE.log.0.20250901050358
```

... TODO 

### 2\. Log Configuration and Modern Integration

Configuring DB2's logging for external systems like Splunk, Loki, and Grafana primarily involves managing the diagnostic log, as it's the only one in a readily parsable, plain-text format.

#### Diagnostic Log Configuration

The most important parameter for managing the diagnostic log is **`DIAGLEVEL`**. This parameter controls the verbosity of the `db2diag.log` file.

  * **`DIAGLEVEL`**: A value from 1 to 4 that sets the level of detail logged. A higher value means more verbose logging. For ETL performance monitoring, a **`DIAGLEVEL`** of 3 or 4 is often useful to capture detailed information on database operations, internal processes, and potential bottlenecks. The `DIAGLEVEL` can be set using the `UPDATE DBM CFG` command.

```bash
db2 update dbm cfg using DIAGLEVEL 4
db2 terminate
```

You can also use the **`DIAGSIZE`** parameter to manage log file size, which is crucial for preventing disk-full errors. DB2 will automatically rotate the diagnostic log when the size limit is reached.

#### Log Forwarding and Compatibility

Since the `db2diag.log` is a plain text file, it's highly compatible with modern log aggregation tools.

  * **Fluentd/Fluent Bit**: These are open-source data collectors that can read log files from a specified path (**`DIAGPATH`**) and forward them to a destination. You'd configure a file input plugin to monitor the `db2diag.log` and a destination plugin (e.g., Loki, Splunk) to send the data.

  * **Loki and Grafana**: Loki is a log aggregation system that works well with semi-structured logs. Since `db2diag.log` entries have a consistent structure (timestamp, PID, message), Loki can easily index them. You would use Grafana's Loki data source to search and visualize these logs. The main challenge is parsing the multi-line log entries. You'll need to configure your Fluent Bit or Promtail agent to recognize the start of a new log entry (e.g., by matching a timestamp at the beginning of a line) and combine all subsequent lines until the next timestamp is found. This ensures each log entry is a single, complete record.

  * **Splunk**: Splunk can ingest log data directly from files. You would set up a file-based data input to monitor the `db2diag.log` file. Splunk's powerful parsing and indexing capabilities can automatically extract fields like the timestamp, PID, and message, making the logs easily searchable.

#### Transaction and Audit Log Integration

As mentioned, transaction and audit logs are not in a human-readable format. Directly forwarding these binary files to a log aggregation platform won't work. The correct approach is to use the native DB2 utilities to extract the information into a usable format first.

  * **Transaction Logs**: To analyze transaction logs for performance or recovery purposes, you must use the `db2fmtlog` utility to format the binary log files. This utility converts the log records into a more readable format, which can then be parsed and forwarded. However, this is more for ad-hoc analysis and not a real-time, continuous monitoring solution.

  * **Audit Logs**: To use audit data, you must use the `db2audit extract` command. This command extracts the binary audit log files into delimited ASCII files. You could then set up an automated script to run this command periodically and have your log forwarding agent pick up the newly generated text files.

For continuous, real-time ETL monitoring, a better approach than scraping logs is to use DB2's built-in monitoring functions and views, such as `MON_GET_WORKLOAD` or `MON_GET_ACTIVITY`, and collect metrics via an API. You can then use tools like Prometheus to scrape these metrics and send them to Grafana for a more performant and real-time dashboard. This is often preferred over log scraping for performance-centric tasks.
