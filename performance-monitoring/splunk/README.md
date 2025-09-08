# DB2 Audit & Splunk Integration Steps 

### 1. Configure DB2 Auditing 

**On the DB2 container (`db2`):**

```bash
# Set audit data and archive path
db2audit configure datapath /database/config/db2inst1/ archivepath /database/config/db2inst1/
# Output:
# AUD0000I  Operation succeeded.

# Create an audit policy for schema changes (DDL)
db2 "CREATE AUDIT POLICY SCHEMA_CHANGES CATEGORIES EXECUTE STATUS BOTH ERROR TYPE AUDIT"
# Output:
# DB20000I  The SQL command completed successfully.

# Enable the audit policy on the database
db2 "AUDIT DATABASE USING POLICY SCHEMA_CHANGES"
# Output:
# DB20000I  The SQL command completed successfully.
```

### 2. Make a Schema Change 

```bash
# Alter table to test auditing
db2 "ALTER TABLE EMPLOYEE ADD COLUMN department VARCHAR(50)"
# Output:
# DB20000I  The SQL command completed successfully.

db2 "ALTER TABLE EMPLOYEE ADD COLUMN location VARCHAR(50);"
# Output: 
# DB20000I  The SQL command completed successfully.
```

### 3. Archive & Extract Audit Logs 

```bash
# Archive the audit logs to ensure they are available for extraction
db2 "CALL SYSPROC.AUDIT_ARCHIVE(NULL, NULL)"
# Output includes path to archived log files.

# List files in audit directory
ls /database/config/db2inst1/
# Example files:
# db2audit.db.SAMPLE.log.0
# db2audit.db.SAMPLE.log.0.20250908032653
# db2audit.db.SAMPLE.log.0.20250908040602.      

# TODO: automate a scheduled job to extract audit logs on regular basis 
# Extract audit records to a readable file
db2audit extract file /database/config/db2inst1/audit.out from files /database/config/db2inst1/db2audit.db.SAMPLE.log.0.20250908032653
# Output:
# AUD0000I  Operation succeeded.

# Ensure Splunk can read the file
chmod 644 /database/config/db2inst1/audit.out
```

### 4. Configure Splunk to Monitor the File 

**On the Splunk container (`splunk`):**

1. Confirm file visibility and permissions:

```bash
ls -l /database/config/db2inst1/audit.out
```

2. List monitored inputs:

```bash
/opt/splunk/bin/splunk list monitor
# Should include:
# /database/config/db2inst1/audit.out
```

3. List indexes to verify `db2_audit` exists:

```bash
/opt/splunk/bin/splunk list index
# Look for:
# db2_audit
```

### 5. Splunk Search Examples 

**Basic query for ALTER TABLE events:**

```spl
index="db2_audit" sourcetype="db2_audit" "statement text=ALTER TABLE"
```

<img width="900" alt="image" src="https://github.com/user-attachments/assets/ffef01de-b56b-4960-b6b5-075f4595c761" />

**Extract table name using `rex`:**

```spl
index="db2_audit" sourcetype="db2_audit" "statement text=ALTER TABLE"
| rex field=_raw "statement text=ALTER TABLE (?<table_name>\w+)"
| table _time, userid, table_name, statement text
```

<img width="900" alt="image" src="https://github.com/user-attachments/assets/961f9ea2-5696-41b3-9307-60a869224df3" />

**Extract added column:**

```spl
index="db2_audit" sourcetype="db2_audit" "statement text=ALTER TABLE"
| rex field=_raw "ALTER TABLE \w+ ADD COLUMN (?<column_name>\w+)"
| table _time, userid, table_name, column_name, statement text
```

<img width="900" alt="image" src="https://github.com/user-attachments/assets/29bbc733-8c01-4b01-86ea-5bb91fa59fa4" />

**Timechart for schema changes:**

```spl
index="db2_audit" sourcetype="db2_audit" "statement text=ALTER TABLE"
| timechart count by table_name
```

<img width="900" alt="image" src="https://github.com/user-attachments/assets/8b4973dd-eb76-48d6-a982-89348d475b98" />
