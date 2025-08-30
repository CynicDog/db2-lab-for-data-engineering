# Administration

This section serves as a fundamental guide to performing core administrative tasks on the DB2 database, with a focus on activities relevant to ETL development and operations.

## 1\. Connecting to the Database

To perform any administrative or data-related task, you must first establish a connection to the database. In your lab environment, you'll use the **DB2 Command Line Processor (CLP)**.

```bash
db2 connect to SAMPLE user DB2INST1
```

  * **`db2`**: The main command to invoke the DB2 CLP.
  * **`connect to SAMPLE`**: Specifies the database you want to connect to. In this case, it's the `SAMPLE` database.
  * **`user DB2INST1`**: Specifies the username for the connection. In your container, `DB2INST1` is the instance owner and has administrative privileges. You can omit the user and password if you're already logged in as the instance owner.

Once connected, you can execute SQL statements directly or use administrative commands.

<details><summary>Example</summary>

```
[db2inst1@662c53b54754 ~]$ db2 connect to SAMPLE user DB2INST1
Enter current password for DB2INST1: 

   Database Connection Information

 Database server        = DB2/LINUXX8664 11.5.8.0
 SQL authorization ID   = DB2INST1
 Local database alias   = SAMPLE
```

</details>

-----

## 2\. Managing Database Objects

As an ETL developer, you'll interact with various database objects. You need to know how to list and inspect them.

### Listing Tables and Views

The `db2 list tables` command is essential for discovery. It provides a quick overview of all tables and views in the current schema.

```bash
db2 list tables
```

  * **`Table/View`**: The name of the object.
  * **`Schema`**: The schema that owns the object. The `DB2INST1` schema is the default for your lab.
  * **`Type`**: Indicates the object type (`T` for Table, `V` for View, `A` for Alias, `S` for Synonym). This helps you quickly distinguish between base tables and virtual objects.
  * **`Creation time`**: The timestamp when the object was created.

<details><summary>Examples</summary>

```
[db2inst1@662c53b54754 ~]$ db2 list tables

Table/View                      Schema          Type  Creation time             
------------------------------- --------------- ----- --------------------------
ACT                             DB2INST1        T     2025-08-30-05.02.03.181785
ADEFUSR                         DB2INST1        S     2025-08-30-05.02.04.198522
CATALOG                         DB2INST1        T     2025-08-30-05.02.06.066403
CL_SCHED                        DB2INST1        T     2025-08-30-05.02.02.709458
CUSTOMER                        DB2INST1        T     2025-08-30-05.02.05.921429
DEPARTMENT                      DB2INST1        T     2025-08-30-05.02.02.745651
DEPT                            DB2INST1        A     2025-08-30-05.02.02.826867
EMP                             DB2INST1        A     2025-08-30-05.02.02.887910
EMPACT                          DB2INST1        A     2025-08-30-05.02.03.180486
EMPLOYEE                        DB2INST1        T     2025-08-30-05.02.02.827551
EMPMDC                          DB2INST1        T     2025-08-30-05.02.04.748625
EMPPROJACT                      DB2INST1        T     2025-08-30-05.02.03.155434
EMP_ACT                         DB2INST1        A     2025-08-30-05.02.03.181273
EMP_PHOTO                       DB2INST1        T     2025-08-30-05.02.02.888322
EMP_RESUME                      DB2INST1        T     2025-08-30-05.02.02.971324
INVENTORY                       DB2INST1        T     2025-08-30-05.02.05.875174
IN_TRAY                         DB2INST1        T     2025-08-30-05.02.03.231813
ORG                             DB2INST1        T     2025-08-30-05.02.03.251549
PRODUCT                         DB2INST1        T     2025-08-30-05.02.05.777024
PRODUCTSUPPLIER                 DB2INST1        T     2025-08-30-05.02.06.209283
PROJ                            DB2INST1        A     2025-08-30-05.02.03.107655
PROJACT                         DB2INST1        T     2025-08-30-05.02.03.108091
PROJECT                         DB2INST1        T     2025-08-30-05.02.03.052688
PURCHASEORDER                   DB2INST1        T     2025-08-30-05.02.05.992956
SALES                           DB2INST1        T     2025-08-30-05.02.03.292385
STAFF                           DB2INST1        T     2025-08-30-05.02.03.271882
STAFFG                          DB2INST1        T     2025-08-30-05.02.04.061593
SUPPLIERS                       DB2INST1        T     2025-08-30-05.02.06.145999
VACT                            DB2INST1        V     2025-08-30-05.02.03.328309
VASTRDE1                        DB2INST1        V     2025-08-30-05.02.03.345506
VASTRDE2                        DB2INST1        V     2025-08-30-05.02.03.347388
VDEPMG1                         DB2INST1        V     2025-08-30-05.02.03.335100
VDEPT                           DB2INST1        V     2025-08-30-05.02.03.317016
VEMP                            DB2INST1        V     2025-08-30-05.02.03.324141
VEMPDPT1                        DB2INST1        V     2025-08-30-05.02.03.343135
VEMPLP                          DB2INST1        V     2025-08-30-05.02.03.363498
VEMPPROJACT                     DB2INST1        V     2025-08-30-05.02.03.332959
VFORPLA                         DB2INST1        V     2025-08-30-05.02.03.355480
VHDEPT                          DB2INST1        V     2025-08-30-05.02.03.323061
VPHONE                          DB2INST1        V     2025-08-30-05.02.03.361921
VPROJ                           DB2INST1        V     2025-08-30-05.02.03.325564
VPROJACT                        DB2INST1        V     2025-08-30-05.02.03.330126
VPROJRE1                        DB2INST1        V     2025-08-30-05.02.03.349033
VPSTRDE1                        DB2INST1        V     2025-08-30-05.02.03.351253
VPSTRDE2                        DB2INST1        V     2025-08-30-05.02.03.353660
VSTAFAC1                        DB2INST1        V     2025-08-30-05.02.03.357165
VSTAFAC2                        DB2INST1        V     2025-08-30-05.02.03.359705

  47 record(s) selected.
```

</details>

-----

## 3\. Database Health and Status

Monitoring the database's status is crucial for troubleshooting and understanding the environment.

### Listing Active Databases

The `db2 list active databases` command shows which databases are currently active and in use.

```bash
db2 list active databases
```

  * **`Database name`**: The name of the active database.
  * **`Applications connected currently`**: The number of current connections. A high number could indicate a busy server, which might impact your ETL job performance.
  * **`Database path`**: The file system location where the database's data files are stored. This is important for tasks like backups and understanding disk space usage.

<details><summary>Examples</summary>

```
[db2inst1@662c53b54754 ~]$ db2 list active databases

                           Active Databases

Database name                              = SAMPLE
Applications connected currently           = 1
Database path                              = /database/data/db2inst1/NODE0000/SQL00001/MEMBER0000/
```

</details>

### Checking Database Configuration

To check various database configuration parameters, you can use the `get db cfg` command. This can be useful for performance tuning and understanding limits, such as memory usage or logging settings.

```bash
db2 get db cfg for SAMPLE
```

<details><summary>Examples</summary>

```
[db2inst1@662c53b54754 ~]$ db2 get db cfg for SAMPLE

       Database Configuration for Database SAMPLE

 Database configuration release level                    = 0x1500
 Database release level                                  = 0x1500

 Update to database level pending                        = NO (0x0)
 Database territory                                      = US
 Database code page                                      = 1208
 Database code set                                       = UTF-8
 Database country/region code                            = 1
 Database collating sequence                             = IDENTITY
 Alternate collating sequence              (ALT_COLLATE) = 
 Number compatibility                                    = OFF
 Varchar2 compatibility                                  = OFF
 Date compatibility                                      = OFF
 Database page size                                      = 8192

 Statement concentrator                      (STMT_CONC) = OFF

 Discovery support for this database       (DISCOVER_DB) = ENABLE

 Restrict access                                         = NO
 Default query optimization class         (DFT_QUERYOPT) = 5
 Degree of parallelism                      (DFT_DEGREE) = 1
 Continue upon arithmetic exceptions   (DFT_SQLMATHWARN) = NO
 Default refresh age                   (DFT_REFRESH_AGE) = 0
 Default maintained table types for opt (DFT_MTTB_TYPES) = SYSTEM
 Number of frequent values retained     (NUM_FREQVALUES) = 10
 Number of quantiles retained            (NUM_QUANTILES) = 20

 Decimal floating point rounding mode  (DECFLT_ROUNDING) = ROUND_HALF_EVEN

 DECIMAL arithmetic mode                (DEC_ARITHMETIC) = 
 Large aggregation                   (LARGE_AGGREGATION) = NO

 Backup pending                                          = NO

 All committed transactions have been written to disk    = YES
 Rollforward pending                                     = NO
 Restore pending                                         = NO

 Upgrade pending                                         = NO

 Multi-page file allocation enabled                      = YES

 Log retain for recovery status                          = NO
 User exit for logging status                            = YES

 Self tuning memory                    (SELF_TUNING_MEM) = ON
 Size of database shared memory (4KB)  (DATABASE_MEMORY) = AUTOMATIC(79840)
 Database memory threshold               (DB_MEM_THRESH) = 100
 Max storage for lock list (4KB)              (LOCKLIST) = AUTOMATIC(4096)
 Percent. of lock lists per application       (MAXLOCKS) = AUTOMATIC(10)
 Package cache size (4KB)                   (PCKCACHESZ) = AUTOMATIC((MAXAPPLS*8))
 Sort heap thres for shared sorts (4KB) (SHEAPTHRES_SHR) = AUTOMATIC(5000)
 Sort list heap (4KB)                         (SORTHEAP) = AUTOMATIC(256)

 Database heap (4KB)                            (DBHEAP) = AUTOMATIC(1200)
 Catalog cache size (4KB)              (CATALOGCACHE_SZ) = 402
 Log buffer size (4KB)                        (LOGBUFSZ) = 2150
 Utilities heap size (4KB)                (UTIL_HEAP_SZ) = AUTOMATIC(5000)
 SQL statement heap (4KB)                     (STMTHEAP) = AUTOMATIC(8192)
 Default application heap (4KB)             (APPLHEAPSZ) = AUTOMATIC(256)
 Application Memory Size (4KB)             (APPL_MEMORY) = AUTOMATIC(40000)
 Statistics heap size (4KB)               (STAT_HEAP_SZ) = AUTOMATIC(4384)

 Interval for checking deadlock (ms)         (DLCHKTIME) = 10000
 Lock timeout (sec)                        (LOCKTIMEOUT) = -1

 Changed pages threshold                (CHNGPGS_THRESH) = 80
 Number of asynchronous page cleaners   (NUM_IOCLEANERS) = AUTOMATIC(4)
 Number of I/O servers                   (NUM_IOSERVERS) = AUTOMATIC(4)
 Sequential detect flag                      (SEQDETECT) = YES
 Default prefetch size (pages)         (DFT_PREFETCH_SZ) = AUTOMATIC

 Track modified pages                         (TRACKMOD) = NO

 Default number of containers                            = 1
 Default tablespace extentsize (pages)   (DFT_EXTENT_SZ) = 32

 Max number of active applications            (MAXAPPLS) = AUTOMATIC(40)
 Average number of active applications       (AVG_APPLS) = AUTOMATIC(1)
 Lifetime of cached credentials   (AUTHN_CACHE_DURATION) = 3
 Max number of users in the cache    (AUTHN_CACHE_USERS) = 0
 Max DB files open per database               (MAXFILOP) = 61440

 Active log space disk capacity (MB)      (LOG_DISK_CAP) = 0
 Log file size (4KB)                         (LOGFILSIZ) = 1024
 Number of primary log files                (LOGPRIMARY) = 16
 Number of secondary log files               (LOGSECOND) = 22
 Changed path to log files                  (NEWLOGPATH) = 
 Path to log files                                       = /database/data/db2inst1/NODE0000/SQL00001/LOGSTREAM0000/
 Overflow log path                     (OVERFLOWLOGPATH) = 
 Mirror log path                         (MIRRORLOGPATH) = 
 First active log file                                   = S0000002.LOG
 Block log on disk full                (BLK_LOG_DSK_FUL) = NO
 Block non logged operations            (BLOCKNONLOGGED) = NO
 Percent max primary log space by transaction  (MAX_LOG) = 0
 Num. of active log files for 1 active UOW(NUM_LOG_SPAN) = 0

 Percent log file reclaimed before soft chckpt (SOFTMAX) = 0
 Target for oldest page in LBP       (PAGE_AGE_TRGT_MCR) = 240

 HADR database role                                      = STANDARD
 HADR local host name                  (HADR_LOCAL_HOST) = 
 HADR local service name                (HADR_LOCAL_SVC) = 
 HADR remote host name                (HADR_REMOTE_HOST) = 
 HADR remote service name              (HADR_REMOTE_SVC) = 
 HADR instance name of remote server  (HADR_REMOTE_INST) = 
 HADR timeout value                       (HADR_TIMEOUT) = 120
 HADR target list                     (HADR_TARGET_LIST) = 
 HADR log write synchronization mode     (HADR_SYNCMODE) = NEARSYNC
 HADR spool log data limit (4KB)      (HADR_SPOOL_LIMIT) = AUTOMATIC(0)
 HADR log replay delay (seconds)     (HADR_REPLAY_DELAY) = 0
 HADR peer window duration (seconds)  (HADR_PEER_WINDOW) = 0

 First log archive method                 (LOGARCHMETH1) = DISK:/database/logs/
 Archive compression for logarchmeth1    (LOGARCHCOMPR1) = OFF
 Options for logarchmeth1                  (LOGARCHOPT1) = 
 Second log archive method                (LOGARCHMETH2) = OFF
 Archive compression for logarchmeth2    (LOGARCHCOMPR2) = OFF
 Options for logarchmeth2                  (LOGARCHOPT2) = 
 Failover log archive path                (FAILARCHPATH) = 
 Number of log archive retries on error   (NUMARCHRETRY) = 5
 Log archive retry Delay (secs)         (ARCHRETRYDELAY) = 20
 Vendor options                              (VENDOROPT) = 

 Auto restart enabled                      (AUTORESTART) = ON
 Index re-creation time and redo index build  (INDEXREC) = SYSTEM (RESTART)
 Log pages during index build            (LOGINDEXBUILD) = OFF
 Default number of loadrec sessions    (DFT_LOADREC_SES) = 1
 Number of database backups to retain   (NUM_DB_BACKUPS) = 12
 Recovery history retention (days)     (REC_HIS_RETENTN) = 90
 Auto deletion of recovery objects    (AUTO_DEL_REC_OBJ) = OFF

 TSM management class                    (TSM_MGMTCLASS) = 
 TSM node name                            (TSM_NODENAME) = 
 TSM owner                                   (TSM_OWNER) = 
 TSM password                             (TSM_PASSWORD) = 

 Automatic maintenance                      (AUTO_MAINT) = ON
   Automatic database backup            (AUTO_DB_BACKUP) = OFF
   Automatic table maintenance          (AUTO_TBL_MAINT) = ON
     Automatic runstats                  (AUTO_RUNSTATS) = ON
       Real-time statistics            (AUTO_STMT_STATS) = ON
       Statistical views              (AUTO_STATS_VIEWS) = OFF
       Automatic sampling                (AUTO_SAMPLING) = ON
       Automatic column group statistics (AUTO_CG_STATS) = OFF
     Automatic reorganization               (AUTO_REORG) = OFF

 Auto-Revalidation                          (AUTO_REVAL) = DEFERRED

 Currently Committed                        (CUR_COMMIT) = ON
 CHAR output with DECIMAL input        (DEC_TO_CHAR_FMT) = NEW
 Enable XML Character operations        (ENABLE_XMLCHAR) = YES
 Enforce Constraint                  (DDL_CONSTRAINT_DEF) = YES
 Enable row compression by default  (DDL_COMPRESSION_DEF) = NO
 Replication site ID                      (REPL_SITE_ID) = 0
 Monitor Collect Settings
 Request metrics                       (MON_REQ_METRICS) = BASE
 Activity metrics                      (MON_ACT_METRICS) = BASE
 Object metrics                        (MON_OBJ_METRICS) = EXTENDED
 Routine data                             (MON_RTN_DATA) = NONE
   Routine executable list            (MON_RTN_EXECLIST) = OFF
 Unit of work events                      (MON_UOW_DATA) = NONE
   UOW events with package list        (MON_UOW_PKGLIST) = OFF
   UOW events with executable list    (MON_UOW_EXECLIST) = OFF
 Lock timeout events                   (MON_LOCKTIMEOUT) = NONE
 Deadlock events                          (MON_DEADLOCK) = WITHOUT_HIST
 Lock wait events                         (MON_LOCKWAIT) = NONE
 Lock wait event threshold               (MON_LW_THRESH) = 5000000
 Number of package list entries         (MON_PKGLIST_SZ) = 32
 Lock event notification level         (MON_LCK_MSG_LVL) = 1

 SMTP Server                               (SMTP_SERVER) = 
 SQL conditional compilation flags         (SQL_CCFLAGS) = 
 Section actuals setting               (SECTION_ACTUALS) = NONE
 Connect procedure                        (CONNECT_PROC) = 
 Adjust temporal SYSTEM_TIME period (SYSTIME_PERIOD_ADJ) = NO
 Log DDL Statements                      (LOG_DDL_STMTS) = NO
 Log Application Information             (LOG_APPL_INFO) = NO
 Default data capture on new Schemas   (DFT_SCHEMAS_DCC) = NO
 Strict I/O for EXTBL_LOCATION         (EXTBL_STRICT_IO) = NO
 Allowed paths for external tables      (EXTBL_LOCATION) = /database/config/db2inst1
 Default table organization              (DFT_TABLE_ORG) = ROW
 Default string units                     (STRING_UNITS) = SYSTEM
 National character string mapping       (NCHAR_MAPPING) = CHAR_CU32
 Database is in write suspend state                      = NO
 Extended row size support             (EXTENDED_ROW_SZ) = ENABLE
 Encryption Library for Backup                 (ENCRLIB) = 
 Encryption Options for Backup                (ENCROPTS) = 

 WLM Collection Interval (minutes)     (WLM_COLLECT_INT) = 0
 Target agent load per CPU core    (WLM_AGENT_LOAD_TRGT) = AUTOMATIC(14)
 WLM admission control enabled      (WLM_ADMISSION_CTRL) = NO
 Allocated share of CPU resources       (WLM_CPU_SHARES) = 1000
 CPU share behavior (hard/soft)     (WLM_CPU_SHARE_MODE) = HARD
 Maximum allowable CPU utilization (%)   (WLM_CPU_LIMIT) = 0
 Activity Sort Memory Limit          (ACT_SORTMEM_LIMIT) = NONE
 Control file recovery path       (CTRL_FILE_RECOV_PATH) = 
 Encrypted database                                      = NO
 Procedural language stack trace        (PL_STACK_TRACE) = NONE
 HADR SSL certificate label             (HADR_SSL_LABEL) = 
 HADR SSL Hostname Validation        (HADR_SSL_HOST_VAL) = OFF

 BUFFPAGE size to be used by optimizer   (OPT_BUFFPAGE) = 0
 LOCKLIST size to be used by optimizer   (OPT_LOCKLIST) = 0
 MAXLOCKS size to be used by optimizer   (OPT_MAXLOCKS) = 0
 SORTHEAP size to be used by optimizer   (OPT_SORTHEAP) = 0
```

```
[db2inst1@662c53b54754 ~]$ db2 get db cfg for SAMPLE
```
> The database configuration for `SAMPLE` provides important details about its setup and performance. Here are some of the most notable configurations from your output:
>
>   * **Data Encoding**: `Database code set = UTF-8`. This is a crucial setting that indicates the database supports a wide range of characters from different languages, which is essential for global data and ETL jobs.
>   * **Concurrency Control**: `Lock timeout (sec) = -1`. A value of `-1` means that any application waiting for a lock will wait forever. This can cause ETL jobs to hang indefinitely if they encounter a lock from another process. In a production environment, this is often set to a specific timeout value (e.g., 60 seconds) to ensure that applications fail quickly and can be restarted.
>   * **Automatic Maintenance**:
>       * `Automatic maintenance (AUTO_MAINT) = ON`. This is a good sign that the database is configured to perform routine maintenance tasks.
>       * `Automatic runstats (AUTO_RUNSTATS) = ON`. This is particularly important for ETL processes. **Runstats** collects information about the data distribution in tables, which the DB2 optimizer uses to create efficient query plans. When this is on, the database automatically keeps this information up-to-date, which is great for the performance of your ETL loads and transformations.
>       * `Automatic reorganization (AUTO_REORG) = OFF`. While `runstats` is on, the database is not configured to automatically reorganize tables and indexes to reclaim space and improve performance. This might be a manual task performed by a DBA.
>   * **Memory Management**: `Self tuning memory (SELF_TUNING_MEM) = ON`. This is a powerful feature where DB2 dynamically manages memory resources for key components like the `LOCKLIST`, `SORTHEAP`, and `PCKCACHESZ` to optimize performance. You can see that many of the memory-related parameters are set to `AUTOMATIC`, indicating this feature is active.
>   * **Transaction Logging**:
>       * `Log file size (4KB) (LOGFILSIZ) = 1024` and `Number of primary log files (LOGPRIMARY) = 16`. These parameters define the size of the transaction log files. When a log file fills up, the database switches to the next one. Understanding these values helps you monitor disk space and prevent the database from stopping due to full logs.
>       * `Path to log files` specifies the directory where all the transaction logs are stored, which is vital for troubleshooting and recovery.
  
</details>

-----

## 4\. User and Access Control

While a DBA typically manages user accounts, as an ETL developer, you must understand how permissions are granted. Your boss mentioned requesting access from a DBA, so knowing what to ask for is key.

### Key Privileges for ETL

  * **`SELECT`**: The most basic permission, required to read data from source tables.
  * **`INSERT`, `UPDATE`, `DELETE`**: These are crucial for loading and transforming data in target tables.
  * **`LOAD`**: A high-performance method for bulk-loading data, often preferred in production ETL processes. This privilege is different from standard `INSERT` and is a key concept for efficient data migration.

The `GRANT` and `REVOKE` statements are used to manage these permissions. For example, to grant `SELECT` on the `EMPLOYEE` table to a user named `etl_user`:

```sql
GRANT SELECT ON TABLE DB2INST1.EMPLOYEE TO USER etl_user;
```

## 5\. Backup and Recovery

Knowing the backup and recovery procedures is essential for data integrity. A failed ETL job could lead to data corruption, and a backup would be the last resort for recovery.

### Backup Command

You can perform a full database backup using the `db2 backup` command. This is often done by a DBA, but understanding its role is important.

```bash
db2 backup db SAMPLE to /path/to/backup/directory
```

