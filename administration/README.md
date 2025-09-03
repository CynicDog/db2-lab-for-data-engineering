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

<details><summary>Examples</summary>

```
[db2inst1@662c53b54754 ~]$ db2 connect to SAMPLE user DB2INST1
Enter current password for DB2INST1: 

   Database Connection Information

 Database server        = DB2/LINUXX8664 11.5.8.0
 SQL authorization ID   = DB2INST1
 Local database alias   = SAMPLE
```

</details>

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

## 4\. User and Access Control

While a DBA typically manages user accounts, as an ETL developer, you must understand how permissions are granted. Your boss mentioned requesting access from a DBA, so knowing what to ask for is key.

### Key Privileges for ETL

As an ETL developer, you'll need specific permissions to perform your tasks. Your boss told you to ask the DBA for access, so you'll want to know exactly what to request. At a minimum, you'll need the following privileges:

  * **`SELECT`**: This is the most basic permission, required to read data from source tables. You can't extract data without it.
  * **`INSERT`, `UPDATE`, `DELETE`**: These are crucial for loading, transforming, and manipulating data in your target tables. **INSERT** is for adding new rows, **UPDATE** is for changing existing ones, and **DELETE** is for removing rows.
  * **`LOAD`**: This is a high-performance method for bulk-loading data, which is often preferred in production ETL processes. This privilege is separate from standard **INSERT** and is key for efficient data migration.

### Step-by-Step User and Access Control

To make this scenario more concrete, let's walk through the full process a DBA would follow, starting with creating a new operating system user and then granting them privileges inside DB2.  
The `db2inst1` user (instance owner) has the necessary administrative privileges to perform these actions.

#### 1. Creating the Operating System User

Unlike databases such as Oracle or PostgreSQL, DB2 does **not** maintain its own internal list of users.  
Instead, DB2 relies on the **underlying operating system (or an external service like LDAP/Kerberos)** for authentication.  

That means before a user can connect to a DB2 database, they must exist at the OS level.  
DB2 itself does not store their password — it delegates authentication to the OS, then applies authorization rules (grants, roles, privileges) internally.

For example, on Linux, a DBA can create the `etl_user` account:

```bash
sudo useradd -m etl_user
sudo passwd etl_user
```

This creates the OS account `etl_user` with a home directory and password.

You can confirm with:

```bash
getent passwd etl_user
```

#### 2. Connecting as the New User

Once the OS account exists, the user can attempt to connect to DB2.
From the shell:

```bash
su - etl_user
db2 connect to SAMPLE user etl_user using <password>
```

If authentication succeeds, DB2 recognizes `etl_user` as a valid user ID.

#### 3. Granting Privileges

By default, a newly created OS user has **no privileges** inside DB2.
A DBA (e.g., `db2inst1`) must explicitly grant permissions.

For example:

```bash
db2 grant connect on database to user etl_user;
```

To give `etl_user` access to specific tables:

```bash
db2 "GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE DB2INST1.SALES TO USER etl_user;"
```

Or on views:

```bash
db2 "GRANT SELECT ON TABLE DB2INST1.EMPLOYEE_VIEW TO USER etl_user;"
```

#### 4. Revoking Privileges

If `etl_user` no longer requires certain access, a DBA can remove privileges:

```sql
db2 "REVOKE INSERT ON TABLE DB2INST1.SALES FROM USER etl_user;"
```

This ensures users only retain the minimum permissions they need.

<details><summary>Examples</summary>

### 1. User Attempts Access Without Privileges

When `etl_user_1` connects to the SAMPLE database and tries to query a table, DB2 denies the request because no privileges were granted:

```bash
[etl_user_1@662c53b54754 ~]$ db2 connect to SAMPLE user etl_user_1 using 'SomePassword'

   Database Connection Information

 Database server        = DB2/LINUXX8664 11.5.8.0
 SQL authorization ID   = ETL_USER_1
 Local database alias   = SAMPLE

[etl_user_1@662c53b54754 ~]$ db2 "select * from DB2INST1.SALES"
SQL0551N  The statement failed because the authorization ID does not have the 
required authorization or privilege to perform the operation.  
Authorization ID: "ETL_USER_1".  Operation: "SELECT".  
Object: "DB2INST1.SALES".  SQLSTATE=42501
```

### 2. DBA Grants Privileges

The DBA (`db2inst1`) must explicitly grant access rights. For example, to allow `etl_user_1` to read and modify the `SALES` table:

```bash
[db2inst1@662c53b54754 ~]$ db2 "GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE DB2INST1.SALES TO USER etl_user_1;"
DB20000I  The SQL command completed successfully.
```

### 3. User Retries With Privileges

Now that the privileges are granted, `etl_user_1` can query the table successfully:

```bash
[etl_user_1@662c53b54754 ~]$ db2 "select * from DB2INST1.SALES"

SALES_DATE SALES_PERSON    REGION          SALES
---------- --------------- --------------- -----------
12/31/2005 LUCCHESSI       Ontario-South             1
12/31/2005 LEE             Ontario-South             3
12/31/2005 LEE             Quebec                    1
12/31/2005 LEE             Manitoba                  2
12/31/2005 GOUNOT          Quebec                    1
03/29/2006 LUCCHESSI       Ontario-South             3
03/29/2006 LUCCHESSI       Quebec                    1
03/29/2006 LEE             Ontario-South             2
03/29/1996 LEE             Ontario-North             2
03/29/2006 LEE             Quebec                    3
03/29/2006 LEE             Manitoba                  5
03/29/2006 GOUNOT          Ontario-South             3
03/29/2006 GOUNOT          Quebec                    1
03/29/2006 GOUNOT          Manitoba                  7
```

</details>

## 5\. Backup and Recovery

Knowing the backup and recovery procedures is essential for **data integrity**. ETL processes often modify large amounts of data, and a failed job could lead to data corruption. Understanding how to safely backup and restore a database is crucial for a DBA or ETL engineer.

### Full Database Backup

You can perform a full database backup using the `db2 backup` command. A **backup requires an exclusive database connection**, so all other connections must be terminated.

#### Step 1: Force all applications off the database

```bash
db2 force applications all
```

* This disconnects all active users from the database to ensure a clean backup.

#### Step 2: Deactivate the database

```bash
db2 deactivate db SAMPLE
```

* Shuts down the database gracefully for backup.

#### Step 3: Run the backup command

```bash
db2 backup db SAMPLE to /database/config/db2inst1/backup/
```

* Replace the path with a valid directory inside the container.
* The output will show a **timestamp** identifying the backup image:

```
Backup successful. The timestamp for this backup image is : 20250830063440
```

### Restore Database from Backup

If the database is corrupted or you need to roll back, restore it using:

```bash
db2 restore db SAMPLE from /database/config/db2inst1/backup/
```

* DB2 will prompt you if you are restoring over an existing database.
* Once confirmed, the database will be restored to the state of the backup image.

<details><summary>Examples</summary>

```
[db2inst1@662c53b54754 ~]$ mkdir backup
[db2inst1@662c53b54754 ~]$ pwd
/database/config/db2inst1
[db2inst1@662c53b54754 ~]$ db2 backup db SAMPLE to //database/config/db2inst1/backup/

Backup successful. The timestamp for this backup image is : 20250830063440

[db2inst1@662c53b54754 ~]$ db2 restore db SAMPLE from /database/config/db2inst1/backup/
SQL2539W  The specified name of the backup image to restore is the same as the 
name of the target database.  Restoring to an existing database that is the 
same as the backup image database will cause the current database to be 
overwritten by the backup version.
Do you want to continue ? (y/n) y
DB20000I  The RESTORE DATABASE command completed successfully.
```

</details>

### Rollforward Recovery

If you are using **log-based recovery** or performing a **point-in-time recovery**, rollforward applies all committed transactions from the logs to bring the database up to date.

#### Step 1: Run Rollforward

```bash
db2 "ROLLFORWARD DATABASE SAMPLE TO END OF LOGS AND STOP OVERFLOW LOG PATH (/database/data/db2inst1/NODE0000/SQL00001/OVERFLOW_LOGS/)"
```

* `TO END OF LOGS` applies all logs up to the last committed transaction.
* `STOP OVERFLOW LOG PATH` specifies where overflow logs are temporarily stored during recovery.

> What are Overflow Logs?
> - DB2 writes transaction activity to active logs to ensure durability and allow recovery.
> - Each log path has a finite space. When the active log fills up before the transaction commits, DB2 can’t continue writing unless there’s additional space.
> - Overflow logs are additional directories that DB2 can use to temporarily store log data if the primary log path is full.
> - During rollforward recovery, DB2 needs to read all committed transactions from the logs to restore the database. If some logs were written to overflow paths, those paths must be accessible, otherwise DB2 will report missing logs.

#### Step 2: Verify Rollforward Completion

Check the rollforward status:

```bash
db2 get db cfg for SAMPLE | grep -i rollforward
```
> This will give an entry that says `Rollforward pending = NO`. 

Activate and connect to the database as: 
```bash
db2 activate db SAMPLE
db2 connect to SAMPLE
```

Verify active connections: 
```bash
db2 list active databases
```

## 6\. Table Space Management

Managing the physical storage of your database objects is critical for performance and availability. The `list tablespaces show detail` command provides a comprehensive view of the storage containers.

```bash
db2 "list tablespaces show detail"
```

The output is broken down by each tablespace and provides vital information about its health and usage.

<details><summary>Examples</summary>

```
[db2inst1@02fbee59ef4e ~]$ db2 "list tablespaces show detail"

           Tablespaces for Current Database

 Tablespace ID                        = 0
 Name                                 = SYSCATSPACE
 Type                                 = Database managed space
 Contents                             = All permanent data. Regular table space.
 State                                = 0x0000
   Detailed explanation:
     Normal
 Total pages                          = 20480
 Useable pages                        = 20476
 Used pages                           = 16652
 Free pages                           = 3824
 High water mark (pages)              = 16652
 Page size (bytes)                    = 8192
 Extent size (pages)                  = 4
 Prefetch size (pages)                = 4
 Number of containers                 = 1

 Tablespace ID                        = 1
 Name                                 = TEMPSPACE1
 Type                                 = System managed space
 Contents                             = System Temporary data
 State                                = 0x0000
   Detailed explanation:
     Normal
 Total pages                          = 1
 Useable pages                        = 1
 Used pages                           = 1
 Free pages                           = Not applicable
 High water mark (pages)              = Not applicable
 Page size (bytes)                    = 8192
 Extent size (pages)                  = 32
 Prefetch size (pages)                = 32
 Number of containers                 = 1

 Tablespace ID                        = 2
 Name                                 = USERSPACE1
 Type                                 = Database managed space
 Contents                             = All permanent data. Large table space.
 State                                = 0x0020
   Detailed explanation:
     Backup pending
 Total pages                          = 4096
 Useable pages                        = 4064
 Used pages                           = 1824
 Free pages                           = 2240
 High water mark (pages)              = 1824
 Page size (bytes)                    = 8192
 Extent size (pages)                  = 32
 Prefetch size (pages)                = 32
 Number of containers                 = 1
 Minimum recovery time                = 2025-08-31-07.29.56.000000

 Tablespace ID                        = 3
 Name                                 = IBMDB2SAMPLEREL
 Type                                 = Database managed space
 Contents                             = All permanent data. Large table space.
 State                                = 0x0000
   Detailed explanation:
     Normal
 Total pages                          = 4096
 Useable pages                        = 4064
 Used pages                           = 672
 Free pages                           = 3392
 High water mark (pages)              = 672
 Page size (bytes)                    = 8192
 Extent size (pages)                  = 32
 Prefetch size (pages)                = 32
 Number of containers                 = 1
 Minimum recovery time                = 2025-08-31-07.42.02.000000

 Tablespace ID                        = 4
 Name                                 = IBMDB2SAMPLEXML
 Type                                 = Database managed space
 Contents                             = All permanent data. Large table space.
 State                                = 0x0000
   Detailed explanation:
     Normal
 Total pages                          = 4096
 Useable pages                        = 4064
 Used pages                           = 1440
 Free pages                           = 2624
 High water mark (pages)              = 1440
 Page size (bytes)                    = 8192
 Extent size (pages)                  = 32
 Prefetch size (pages)                = 32
 Number of containers                 = 1

 Tablespace ID                        = 5
 Name                                 = SYSTOOLSPACE
 Type                                 = Database managed space
 Contents                             = All permanent data. Large table space.
 State                                = 0x0000
   Detailed explanation:
     Normal
 Total pages                          = 4096
 Useable pages                        = 4092
 Used pages                           = 104
 Free pages                           = 3988
 High water mark (pages)              = 104
 Page size (bytes)                    = 8192
 Extent size (pages)                  = 4
 Prefetch size (pages)                = 4
 Number of containers                 = 1
 Minimum recovery time                = 2025-08-31-06.42.21.000000
```

</details>

### DB2 Tablespace Key Attributes

A **tablespace** in DB2 is a logical storage unit that holds tables, indexes, and large objects (LOBs). Understanding its attributes is essential for **database design, performance tuning, and troubleshooting**.

### Key Attributes Explained

* **`Tablespace ID`**
  A unique numerical identifier for the tablespace.

* **`Name`**
  The human-readable name of the tablespace. Common examples:

  * **`SYSCATSPACE`** – Stores the database’s system catalog tables (metadata about all objects).
  * **`TEMPSPACE1`** – Used for temporary data during operations like sorts, joins, or other complex queries. Data here is **non-persistent**.
  * **`USERSPACE1`**, **`IBMDB2SAMPLEREL`** – User-defined tablespaces where your data tables (e.g., `EMPLOYEE`, `SALES`) are stored.

* **`Type`**
  Defines the storage management method:

  * **Database Managed Space (DMS)** – DB2 directly manages storage containers (files or devices). Modern and recommended.
  * **System Managed Space (SMS)** – The OS file system manages storage containers. Older method with some limitations.

* **`Contents`**
  Describes the type of data stored. For example:

  * `All permanent data` – Stores user tables and indexes.
  * `Temporary data` – Only used during query execution, like `TEMPSPACE1`.

* **`State`**
  The current operational condition of the tablespace. This is critical for **troubleshooting**. Possible states include:

  | State                   | Hex Code | Description                                                                                                          |
  | ----------------------- | -------- | -------------------------------------------------------------------------------------------------------------------- |
  | **Normal**              | `0x0000` | Fully functional; read and write operations are allowed.                                                             |
  | **Backup Pending**      | `0x0020` | Tablespace restored from backup but no new backup taken. Writes are **restricted** until a full backup is completed. |
  | **Copy Pending**        | `0x0040` | A backup copy is required before any further modifications; mostly used in DB2 High Availability setups.             |
  | **Quiesced**            | `0x0080` | Tablespace is temporarily frozen; no changes allowed.                                                                |
  | **Rollforward Pending** | `0x0100` | Tablespace needs log-based recovery (rollforward) before becoming available.                                         |
  | **Recover Pending**     | `0x0200` | A recovery operation is required due to errors or incomplete operations.                                             |
  | **Offline**             | `0x0400` | Tablespace is offline and inaccessible.                                                                              |
  | **Load Pending**        | `0x0800` | Tablespace is waiting for a bulk load to complete.                                                                   |
  | **Backup In Progress**  | `0x1000` | A backup operation is currently running on the tablespace.                                                           |

* **`Page size (bytes)`**
  The fundamental unit of storage. DB2 reads/writes in **chunks of this size**. Larger pages can be more efficient for large rows but may waste space for small rows.

* **`Extent size (pages)`**
  The number of pages DB2 allocates at once when the tablespace needs more space. Think of it as **allocating blocks of pages together**.

* **`Total pages`**, **`Useable pages`**, **`Used pages`**, **`Free pages`**
  Metrics that describe storage capacity and usage:

  * `Total pages` – Maximum pages allocated for the tablespace.
  * `Useable pages` – Pages available for table data.
  * `Used pages` – Pages currently holding data.
  * `Free pages` – Pages available for new data.

* **`High water mark (pages)`**
  The peak number of pages ever used. Even if rows are deleted later, the high water mark **does not decrease**, and the tablespace cannot shrink below this level automatically. Critical for **capacity planning**.

## 7\. DB2 System Queries: Production-Level Insights

For a production environment, your administrative toolkit must extend beyond basic queries. You need to understand how to diagnose performance bottlenecks, manage storage, and audit security by querying the system catalog and administrative views. These queries are the foundation for any serious DB2 administration or ETL operations.

### Part A: Advanced Schema and Object Discovery

Going beyond simple table listings, these queries help you understand the full structure of the database and its dependencies.

#### 1\. Listing All Database Objects by Type

The `SYSCAT.TABLES` view contains more than just tables; it's the master list of all table-like objects. Using the `TYPE` column, you can filter for specific object types, which is essential for understanding the data landscape.

**Query:**

```sql
db2 "SELECT TABSCHEMA, TABNAME, TYPE, REMARKS FROM SYSCAT.TABLES WHERE TABSCHEMA = 'DB2INST1' ORDER BY TYPE, TABNAME"
```

  * **`TYPE`**: This is the key column. Common values include:
      * `T`: Table
      * `V`: View
      * `S`: Synonym (or Alias)
      * `A`: Alias
      * `G`: Global Temporary Table
      * `H`: Hierarchy Table

#### 2\. Finding All Stored Procedures, Functions, and Packages

ETL processes often rely on stored procedures and user-defined functions (UDFs). It's critical to know what's available and who created it.

```sql
db2 "SELECT PROCSCHEMA, PROCNAME, CREATE_TIME, SPECIFICNAME FROM SYSCAT.PROCEDURES WHERE PROCSCHEMA NOT LIKE 'SYS%' ORDER BY PROCNAME"
```

<details><summary>Examples</summary>

```
[db2inst1@bf1393c8be44 ~]$ db2 "SELECT routinename, routineschema, text
FROM syscat.routines
WHERE specificname = 'BONUS_INCREASE';"

ROUTINENAME     ROUTINESCHEMA                    TEXT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
BONUS_INCREASE  DB2INST1

CREATE PROCEDURE bonus_increase (
  IN p_bonusFactor DECIMAL (3,2),
  IN p_bonusMaxSumForDept DECIMAL (9,2),
  OUT p_deptsWithoutNewBonuses VARCHAR(255),
  OUT p_countDeptsViewed INTEGER,
  OUT p_countDeptsBonusChanged INTEGER,
  OUT p_errorMsg VARCHAR(255)
)

SPECIFIC BONUS_INCREASE
LANGUAGE SQL
DYNAMIC RESULT SETS 1

BEGIN
-- -------------------------------------------------------------------------------------
-- Routine type:  SQL stored procedure
-- Routine name:  bonus_increase
--
-- Purpose:  This procedure takes in a multiplier value that is used to update
--           employee bonus values.  The employee bonus updates are done department
--           by department.  Updated employee bonus values are only committed if the
--           sum of the bonuses for a department does not exceed the threshold amount
--           specified by another input parameter.  A result is returned listing, by
--           department, employee numbers and currently set bonus values.
--
-- Features shown:
--           - IN and OUT parameters
--           - Variable declaration and setting
--           - Condition handler declaration and use
--           - Use of CURSOR WITH HOLD
--           - Use of SAVEPOINT and ROLLBACK to SAVEPOINT
--           - Returning of a result set to the caller
--           - Use of a WHILE loop control-statement
--           - Use of IF/ELSE statement
--           - Use of labels and GOTO statement
--           - Use of RETURN statement
--
-- Parameters:
-- IN  p_bonusFactor:      Constant multiple by which employee bonuses are updated
-- IN  p_bonusMaxSumForDept:    Maximum amount for departmental bonuses without review
-- OUT p_deptsWithoutNewBonuses:  Comma delimited list of departments that require
--                                   a manual setting and review of bonus amounts
-- OUT p_countDeptsViewed:     Number of departments processed
-- OUT p_countDeptsBonusChanged:  Number of departments for which bonuses were set
-- OUT p_errorMsg:       Error message string
-- --------------------------------------------------------------------------------------
    DECLARE v_dept, v_actdept CHAR(3);
    DECLARE v_bonus, v_deptbonus, v_newbonus DECIMAL(9,2);
    DECLARE v_empno CHAR(6);
    DECLARE v_atend SMALLINT DEFAULT 0;

    -- Cursor that lists employee numbers and bonuses ordered by department
    -- This cursor is declared as WITH HOLD so that on rollbacks it remains
    -- open.  It is declared as FOR UPDATE OF bonus, so that the employee
    -- bonus column field can be updated as the cursor iterates through the rows.

    DECLARE cSales CURSOR WITH HOLD FOR
          SELECT workdept, bonus, empno FROM employee ORDER BY workdept
      FOR UPDATE OF bonus;

    -- This cursor, declared with WITH RETURN TO CALLER, is used to return
    -- a result set to the caller when this procedure returns.  The result
    -- set contains a list of the employees and their bonus values ordered
    -- by the department numbers.

    DECLARE cEmpBonuses CURSOR WITH RETURN TO CALLER FOR
          SELECT workdept, empno, bonus FROM employee ORDER BY workdept;

    -- This continue handler is used to catch the NOT FOUND error
    -- associated with the end of the iteration over the cursor cSales.
    -- It is used to set v_atend which flags the end of the WHILE loop.

     DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_atend=1;

    -- This continue handler is used to catch any numeric overflows

    DECLARE EXIT HANDLER FOR SQLSTATE '22003'
    BEGIN
      SET p_errorMsg = 'SQLSTATE 22003 - Numeric overflow occurred setting bonus';
    END;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION SET v_atend=1;

    -- Initialize local variables

    SET p_errorMsg = '';
    SET p_deptsWithoutNewBonuses = '';
    SET p_countDeptsViewed = 0;
    SET p_countDeptsBonusChanged = 0;

    -- Check input parameter is valid

    IF (p_bonusFactor < 1 OR p_bonusFactor > 2) THEN
      SET p_errorMsg = 'E01 Checking parameter p_bonusFactor, validation';
      GOTO error_found;
    END IF;

    OPEN cSales;

    FETCH cSales INTO v_dept, v_bonus, v_empno;

    nextdept:
        IF v_atend = 0 THEN

            -- This savepoint is used to rollback the bonuses assigned to employees if
            -- the sum of bonuses for a department exceeds a threshold amount

            SAVEPOINT svpt_bonus ON ROLLBACK RETAIN CURSORS;

            SET v_actdept = v_dept;
            SET v_deptbonus = 0;

            WHILE ( v_actdept = v_dept ) AND ( v_atend = 0 ) DO
                    SET v_newbonus = v_bonus * p_bonusFactor;
                    UPDATE employee SET bonus = v_newbonus WHERE empno = v_empno;
                    SET v_deptbonus = v_deptbonus + v_newbonus;
                    FETCH cSales INTO v_dept, v_bonus, v_empno;
            END WHILE;

            SET p_countDeptsViewed = p_countDeptsViewed + 1;

            IF v_deptbonus <= p_bonusMaxSumForDept THEN
                SET p_countDeptsBonusChanged = p_countDeptsBonusChanged + 1;
                COMMIT;
            ELSE
                     ROLLBACK TO SAVEPOINT svpt_bonus;
                     RELEASE SAVEPOINT svpt_bonus;
                     SET p_deptsWithoutNewBonuses =
                                     (CASE WHEN p_deptsWithoutNewBonuses = ''
                                           THEN v_actdept
                                      ELSE
                                           p_deptsWithoutNewBonuses || ', ' || v_actdept
                                      END);
            END IF;
            GOTO nextdept;
        END IF;

    OPEN cEmpBonuses;

    RETURN 0;

error_found:
    SET p_errorMsg = p_errorMsg || ' failed.';
    RETURN -1;

END
```

</details>

```sql
db2 "SELECT FUNCSCHEMA, FUNCNAME, CREATE_TIME, SPECIFICNAME FROM SYSCAT.FUNCTIONS WHERE FUNCSCHEMA NOT LIKE 'SYS%' ORDER BY FUNCNAME"
```

<details><summary>Examples</summary>

```
[db2inst1@bf1393c8be44 ~]$ db2 "
> SELECT routineschema,
>        routinename,
>        specificname,
>        text
> FROM syscat.routines
> WHERE specificname = 'SQL250902230926756';"

ROUTINESCHEMA      ROUTINENAME      SPECIFICNAME         TEXT 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
DB2INST1           RESIGN_EMPLOYEE  SQL250902230926756

CREATE FUNCTION resign_employee (number CHAR(6))
  RETURNS TABLE (empno  CHAR(6),
                 salary DOUBLE,
                 dept   CHAR(3))
  MODIFIES SQL DATA
  LANGUAGE SQL
  BEGIN ATOMIC
-- -------------------------------------------------------------------------------------
-- Routine type:  SQL table function
-- Routine name:  resign_employee
--
-- Purpose:  This procedure takes in an employee number, then removes that
--           employee from the EMPLOYEE table.
--           A useful extension to this function would be to archive the
--           original record into an archive table.
--
-- --------------------------------------------------------------------------------------
    DECLARE l_salary DOUBLE;
    DECLARE l_job CHAR(3);

    SET (l_salary, l_job) = (SELECT salary, job
                               FROM OLD TABLE (DELETE FROM employee
                                                WHERE employee.empno = number));

    RETURN VALUES (number,l_salary, l_job);
  END
```

</details>

  * `SYSCAT.PROCEDURES` and `SYSCAT.FUNCTIONS` are your go-to views.
  * The `WHERE PROCSCHEMA NOT LIKE 'SYS%'` clause is a standard practice to exclude built-in IBM system procedures and focus on user-created objects.

### Part B: RBAC (Role-Based Access Control) 

DB2's security model is based on authorities, roles, and privileges. Understanding these concepts and how to query them is essential for auditing and managing user access in a production environment.

#### 1\. Authorities & Roles

**Authority** in DB2 is a high-level privilege that allows a user to perform a set of administrative tasks across an instance or database. A **role** is a named collection of privileges that can be granted to a user, group, or other roles. Roles simplify permission management by allowing administrators to bundle common privileges and manage them as a single entity.

**What is Authority?**

The `SYSCAT.DBAUTH` catalog view shows database-level authorities granted to users and groups. These authorities are for managing the database itself, not specific objects.

```sql
db2 "SELECT * FROM SYSCAT.DBAUTH"
```

  * **`GRANTEE`**: The user or group that has the authority.
  * **`GRANTEETYPE`**: Specifies if the grantee is a user (`U`), group (`G`), or role (`R`).
  * **`DBADMAUTH`**: `Y` if the user has `DBADM` authority, the highest level of database-specific control.
  * **`CONNECTAUTH`**: `Y` if the user can connect to the database. This is a fundamental permission.
  * **`SECADM`**: `Y` if the user has `SECADM` authority, which allows them to manage security-related objects like roles and trusted contexts.

<details><summary>Examples</summary>

```
[db2inst1@bf1393c8be44 ~]$ db2 "SELECT * FROM SYSCAT.DBAUTH"

GRANTOR                                                                                                                          GRANTORTYPE GRANTEE                                                                                                                          GRANTEETYPE BINDADDAUTH CONNECTAUTH CREATETABAUTH DBADMAUTH EXTERNALROUTINEAUTH IMPLSCHEMAAUTH LOADAUTH NOFENCEAUTH QUIESCECONNECTAUTH LIBRARYADMAUTH SECURITYADMAUTH SQLADMAUTH WLMADMAUTH EXPLAINAUTH DATAACCESSAUTH ACCESSCTRLAUTH CREATESECUREAUTH
-------------------------------------------------------------------------------------------------------------------------------- ----------- -------------------------------------------------------------------------------------------------------------------------------- ----------- ----------- ----------- ------------- --------- ------------------- -------------- -------- ----------- ------------------ -------------- --------------- ---------- ---------- ----------- -------------- -------------- ----------------
SYSIBM                                                                                                                           S           DB2INST1                                                                                                                         U           N           N           N             Y         N                   N              N        N           N                  N              Y               N          N          N           Y              Y              N               
SYSIBM                                                                                                                           S           PUBLIC                                                                                                                           G           Y           Y           Y             N         N                   Y              N        N           N                  N              N               N          N          N           N              N              N               
DB2INST1                                                                                                                         U           ETL_ADMIN                                                                                                                        R           N           N           N             N         N                   N              N        N           N                  N              N               Y          N          N           N              N              N               
DB2INST1                                                                                                                         U           DB2IADM1                                                                                                                         G           N           N           N             N         N                   N              N        N           N                  N              N               Y          N          N           N              N              N               
```

</details>

**What are Roles?**

Roles are a powerful way to implement **RBAC**. They provide a layer of abstraction between the user and their privileges, making it easier to manage access in a complex environment.

The `SYSCAT.ROLES` view lists all defined roles in the database.

```sql
db2 "SELECT * FROM SYSCAT.ROLES"
```
  * **`ROLENAME`**: The name of the role.

<details><summary>Examples</summary>

```
[db2inst1@bf1393c8be44 ~]$ db2 "SELECT * FROM SYSCAT.ROLES"

ROLENAME                                                                                                                         ROLEID      CREATE_TIME                AUDITPOLICYID AUDITPOLICYNAME                                                                                                                  AUDITEXCEPTIONENABLED REMARKS                                                                                                                                                                                                                                                       
-------------------------------------------------------------------------------------------------------------------------------- ----------- -------------------------- ------------- -------------------------------------------------------------------------------------------------------------------------------- --------------------- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SYSDEBUGPRIVATE                                                                                                                           12 2025-09-02-23.08.41.055027             - -                                                                                                                                N                     -                                                                                                                                                                                                                                                             
ETL_ADMIN                                                                                                                               1000 2025-09-02-23.42.40.917066             - -                                                                                                                                N                     -                                                                                                                                                                                                                                                             
SYSTS_MGR                                                                                                                                  9 2025-09-02-23.08.41.055005             - -                                                                                                                                N                     -                                                                                                                                                                                                                                                             
SYSDEBUG                                                                                                                                  11 2025-09-02-23.08.41.055020             - -                                                                                                                                N                     -                                                                                                                                                                                                                                                             
DB2_MONITOR                                                                                                                             1001 2025-09-02-23.44.25.264075             - -                                                                                                                                N                     -                                                                                                                                                                                                                                                             
SYSTS_ADM                                                                                                                                  8 2025-09-02-23.08.41.054998             - -                                                                                                                                N                     -                                                                                                                                                                                                                                                             
SYSTS_USR                                                                                                                                 10 2025-09-02-23.08.41.055013             - -                                                                                                                                N                     -                                                                                                                                                                                                                                                             

  7 record(s) selected.
```

</details>

The `SYSCAT.ROLEAUTH` view shows which users, groups, or roles have been granted a specific role.
**Query:**

```sql
db2 "SELECT * FROM SYSCAT.ROLEAUTH"
```

  * **`ROLEID`**: The role that has been granted.
  * **`GRANTEETYPE`**: The type of grantee (user, group, or role).
  * **`GRANTEE`**: The user, group, or role that received the grant.

<details><summary>Examples</summary>

```
[db2inst1@bf1393c8be44 ~]$ db2 "SELECT * FROM SYSCAT.ROLEAUTH"

GRANTOR                                                                                                                          GRANTORTYPE GRANTEE                                                                                                                          GRANTEETYPE ROLENAME                                                                                                                         ROLEID      ADMIN
-------------------------------------------------------------------------------------------------------------------------------- ----------- -------------------------------------------------------------------------------------------------------------------------------- ----------- -------------------------------------------------------------------------------------------------------------------------------- ----------- -----
SYSIBM                                                                                                                           S           DB2INST1                                                                                                                         U           SYSTS_ADM                                                                                                                                  8 N    
SYSIBM                                                                                                                           S           DB2INST1                                                                                                                         U           SYSTS_MGR                                                                                                                                  9 N    
SYSIBM                                                                                                                           S           DB2INST1                                                                                                                         U           SYSDEBUG                                                                                                                                  11 N    
SYSIBM                                                                                                                           S           DB2INST1                                                                                                                         U           SYSDEBUGPRIVATE                                                                                                                           12 N    
SYSIBM                                                                                                                           S           PUBLIC                                                                                                                           G           SYSTS_USR                                                                                                                                 10 N    

  5 record(s) selected.
```

</details>

#### 2\. Object Privileges

Object privileges are permissions granted on specific database objects like tables, views, routines, and packages. These queries are crucial for auditing who can access or modify a particular piece of data.

**Privileges on Tables and Views**

The `SYSCAT.TABAUTH` and `SYSCAT.VIEWAUTH` views show who has privileges on a table or view.

```sql
db2 "SELECT GRANTEE, GRANTEETYPE, TABSCHEMA, TABNAME, CONTROLAUTH, SELECTAUTH, INSERTAUTH, DELETEAUTH, UPDATEAUTH, ALTERAUTH, INDEXAUTH FROM SYSCAT.TABAUTH WHERE TABSCHEMA = 'DB2INST1' AND TABNAME = 'EMPLOYEE'"
```

  * **`SELECTAUTH`**: `Y` if the grantee can select rows from the table.
  * **`INSERTAUTH`**: `Y` if the grantee can insert new rows.
  * **`UPDATEAUTH`**: `Y` if the grantee can update rows.
  * **`DELETEAUTH`**: `Y` if the grantee can delete rows.
  * **`CONTROLAUTH`**: The highest level of privilege on an object, essentially an `object-level DBADM`. A user with `CONTROLAUTH` can drop the table, grant privileges on it to others, and perform any action.

<details><summary>Examples</summary>

```
[db2inst1@bf1393c8be44 ~]$ db2 "SELECT GRANTEE, GRANTEETYPE, TABSCHEMA, TABNAME, CONTROLAUTH, SELECTAUTH, INSERTAUTH, DELETEAUTH, UPDATEAUTH, ALTERAUTH, INDEXAUTH FROM SYSCAT.TABAUTH WHERE TABSCHEMA = 'DB2INST1' AND TABNAME = 'EMPLOYEE'"

GRANTEE                                                                                                                          GRANTEETYPE TABSCHEMA                                                                                                                        TABNAME                                                                                                                          CONTROLAUTH SELECTAUTH INSERTAUTH DELETEAUTH UPDATEAUTH ALTERAUTH INDEXAUTH
-------------------------------------------------------------------------------------------------------------------------------- ----------- -------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------------------------------------------------------------------------------------- ----------- ---------- ---------- ---------- ---------- --------- ---------
DB2INST1                                                                                                                         U           DB2INST1                                                                                                                         EMPLOYEE                                                                                                                         Y           G          G          G          G          G         G        

  1 record(s) selected.
```

</details>

**Privileges on Routines (Procedures and Functions)**

The `SYSCAT.ROUTINEAUTH` view shows who has permission to execute a stored procedure or user-defined function.

```sql
db2 "SELECT SPECIFICNAME, GRANTOR, GRANTEE, GRANTEETYPE, EXECUTEAUTH FROM SYSCAT.ROUTINEAUTH"
```

<details><summary>Examples</summary>

```

[db2inst1@bf1393c8be44 ~]$ db2 "SELECT SPECIFICNAME, GRANTOR, GRANTEE, GRANTEETYPE, EXECUTEAUTH FROM SYSCAT.ROUTINEAUTH"

SPECIFICNAME                                                                                                                     GRANTOR                                                                                                                          GRANTEE                                                                                                                          GRANTEETYPE EXECUTEAUTH
-------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------------------------------------------------------------------------------------- ----------- -----------
SQL250902230843636                                                                                                               SYSIBM                                                                                                                           DB2INST1                                                                                                                         U           G          
SQL250902230843636                                                                                                               SYSIBM                                                                                                                           PUBLIC                                                                                                                           G           Y          
SQL250902230843637                                                                                                               SYSIBM                                                                                                                           DB2INST1                                                                                                                         U           G          
SQL250902230843637                                                                                                               SYSIBM                                                                                                                           PUBLIC                                                                                                                           G           Y          
SQL250902230843738                                                                                                               SYSIBM                                                                                                                           DB2INST1                                                                                                                         U           G          
SQL250902230843738                                                                                                               SYSIBM                                                                                                                           PUBLIC                                                                                                                           G           Y          
SQL250902230843739                                                                                                               SYSIBM                                                                                                                           DB2INST1                                                                                                                         U           G          
SQL250902230843739                                                                                                               SYSIBM                                                                                                                           PUBLIC                                                                                                                           G           Y          
SQL250902230843740                                                                                                               SYSIBM                                                                                                                           DB2INST1                                                                                                                         U           G          
SQL250902230843740                                                                                                               SYSIBM                                                                                                                           PUBLIC                                                                                                                           G           Y          
SQL250902230843741                                                                                                               SYSIBM                                                                                                                           DB2INST1                                                                                                                         U           G          
SQL250902230843741                                                                                                               SYSIBM                                                                                                                           PUBLIC                                                                                                                           G           Y          
SQL250902230843742                                                                                                               SYSIBM                                                                                                                           DB2INST1                                                                                                                         U           G          
SQL250902230843742                                                                                                               SYSIBM                                                                                                                           PUBLIC                                                                                                                           G           Y          
SQL250902230843743                                                                                                               SYSIBM                                                                                                                           DB2INST1                                                                                                                         U           G          
SQL250902230843743                                                                                                               SYSIBM                                                                                                                           PUBLIC                                                                                                                           G           Y          
SQL250902230843744                                                                                                               SYSIBM                                                                                                                           DB2INST1                                                                                                                         U           G          
```

</details>

**Privileges on Packages**

Packages contain the executable forms of static SQL statements. Granting `EXECUTE` on a package allows a user to run the SQL statements it contains.

```sql
db2 "SELECT GRANTEE, GRANTEETYPE, PKGSCHEMA, PKGNAME, EXECUTEAUTH, BINDAUTH FROM SYSCAT.PACKAGEAUTH WHERE PKGSCHEMA = 'DB2INST1'"
```

  * **`EXECUTEAUTH`**: `Y` if the grantee can execute the statements in the package.
  * **`BINDAUTH`**: `Y` if the grantee can bind the package.

<details><summary>Examples</summary>

```
[db2inst1@bf1393c8be44 ~]$ db2 "SELECT GRANTEE, GRANTEETYPE, PKGSCHEMA, PKGNAME, EXECUTEAUTH, BINDAUTH FROM SYSCAT.PACKAGEAUTH WHERE PKGSCHEMA = 'DB2INST1'"

GRANTEE                                                                                                                          GRANTEETYPE PKGSCHEMA                                                                                                                        PKGNAME                                                                                                                          EXECUTEAUTH BINDAUTH
-------------------------------------------------------------------------------------------------------------------------------- ----------- -------------------------------------------------------------------------------------------------------------------------------- -------------------------------------------------------------------------------------------------------------------------------- ----------- --------
DB2INST1                                                                                                                         U           DB2INST1                                                                                                                         P738305543                                                                                                                       G           G       

  1 record(s) selected.
```

</details>

    
### Part C: Performance and Locking Diagnostics

#### 1\. Detailed Locking Information

#### 2\. Finding Long-Running Statements

### Part D: Storage and Resource Management

#### 1\. Detailed Bufferpool Information

#### 2\. Tablespace Containers and Disk Usage

### Part E: Auditing and Security

#### 1\. Finding Grants and Privileges on Objects

#### 2\. Auditing Object Changes


