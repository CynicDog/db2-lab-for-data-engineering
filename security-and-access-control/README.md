## DB2 RBAC (Role-Based Access Control) 

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

#### 📌 Scenario Example: Payroll System

##### Step 1: Define Roles

```sql
-- Role for payroll analysts
CREATE ROLE PAYROLL_ANALYST;

-- Role for HR managers (more privileges)
CREATE ROLE HR_MANAGER;
```

##### Step 2: Grant Object Privileges to Roles

```sql
-- PAYROLL_ANALYST can read employee and salary tables
GRANT SELECT ON TABLE HR.EMPLOYEES TO ROLE PAYROLL_ANALYST;
GRANT SELECT ON TABLE HR.SALARIES TO ROLE PAYROLL_ANALYST;

-- HR_MANAGER can update salary info
GRANT SELECT, UPDATE ON TABLE HR.SALARIES TO ROLE HR_MANAGER;
```

##### Step 3: Grant Roles to Users

```sql
-- Alice is a payroll analyst
GRANT PAYROLL_ANALYST TO USER ALICE;

-- Bob is HR manager (inherits payroll privileges as well)
GRANT HR_MANAGER TO USER BOB;
```

* **Alice** can only **read** employee and salary data.
* **Bob** can **read & update** salary data.

##### Step 4: Authorities (Optional)

```sql
-- HR_MANAGER role also includes DBADM-like authority for auditing
GRANT DATAACCESS ON DATABASE TO ROLE HR_MANAGER;
```

* Bob can now also **connect and run certain system-level queries**, while Alice cannot.

##### Step 5: Role Hierarchy (Optional)

```sql
-- Make HR_MANAGER inherit PAYROLL_ANALYST automatically
GRANT PAYROLL_ANALYST TO ROLE HR_MANAGER;
```

* Now anyone with HR\_MANAGER also gets all privileges of PAYROLL\_ANALYST.

#### How it All Works Together

| User  | Roles Assigned   | Object Privileges via Roles                                            | Authorities via Roles |
| ----- | ---------------- | ---------------------------------------------------------------------- | --------------------- |
| Alice | PAYROLL\_ANALYST | SELECT on EMPLOYEES, SALARIES                                          | None                  |
| Bob   | HR\_MANAGER      | SELECT, UPDATE on SALARIES, SELECT on EMPLOYEES (via PAYROLL\_ANALYST) | DATAACCESS            |

* When **Alice runs a query**, DB2 checks:

  1. Does she have a role granting the privilege? → Yes (`PAYROLL_ANALYST`)
  2. Does she have the required object privilege? → Yes (`SELECT`)
* When **Bob runs a query**, DB2 checks:

  1. Roles → `HR_MANAGER`
  2. Object privileges → `UPDATE` allowed on SALARIES table
  3. Authorities → `DATAACCESS` allows reading system tables
