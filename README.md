# Db2 Docker Lab Setup for SQL/ETL Practice

This repository contains instructions to set up a **Db2 instance in Docker** on macOS (Intel or Apple Silicon) with a pre-populated sample database for SQL and ETL exercises.

## Prerequisites

- Docker Desktop installed on macOS
- At least **4GB memory** allocated to Docker
- Basic familiarity with command line and SQL

## Step 1: Run the Db2 Container

Run the following command to start a Db2 container with:

- **SAMPLE database** for practice
- Optional **TESTDB** database

```bash
docker run -itd \
  --name mydb2 \
  --platform linux/amd64 \
  --privileged=true \
  -p 50000:50000 \
  -e LICENSE=accept \
  -e DB2INST1_PASSWORD=YourStrongPasswordHere \
  -e DBNAME=TESTDB \
  -e SAMPLEDB=true \
  ibmcom/db2
````
> ⚠️ On Apple Silicon, the `--platform linux/amd64` flag ensures compatibility with the official Db2 image.


## Step 2: Enter the Container

```bash
docker exec -it mydb2 bash
su - db2inst1
```

## Step 3: Source the Db2 Profile

Locate the `sqllib` directory and source the `db2profile`:

```bash
find / -type d -name sqllib 2>/dev/null
. /database/config/db2inst1/sqllib/db2profile
```

## Step 4: Check Databases

List the databases in the directory:

```bash
db2 list db directory
```

Expected output should include:

* `SAMPLE`
* `TESTDB` (if DBNAME specified)

Connect to the SAMPLE database:

```bash
db2 connect to sample
```

Check active databases:

```bash
db2 list active databases
```

## Step 5: List Tables in SAMPLE Database

```bash
db2 list tables
```

You should see pre-populated tables such as:

* `EMPLOYEE`, `DEPARTMENT`, `CUSTOMER`, `PRODUCT`, `PURCHASEORDER`
* Support tables: `ACT`, `EMPACT`, `EMPPROJACT`
* Views: `VEMP`, `VDEPT`, `VPROJACT`, etc.
