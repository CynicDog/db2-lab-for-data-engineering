## 1\. Data Retrieval and Inspection

This section is all about the fundamentals of fetching data from a database. Before you can transform data, you need to understand how to get it, filter it, and look at it from different angles. This is the cornerstone of any ETL process.

### Basic Data Selection (`SELECT`)

The most fundamental SQL command is `SELECT`. It allows you to choose columns and rows from a table. In an ETL context, you'll use this to get a feel for the data in your source tables.

  * **Select all columns:**

    ```sql
    SELECT * FROM EMPLOYEE;
    ```

    This is useful for a quick, initial look at a table. However, in production ETL, it's generally best to specify the columns you need to avoid transferring unnecessary data.

  * **Select specific columns:**

    ```sql
    SELECT EMPNO, FIRSTNME, LASTNAME, SALARY FROM EMPLOYEE;
    ```

    This is the best practice for ETL pipelines, as it optimizes performance by only retrieving the data you'll be using.

### Filtering and Sorting (`WHERE`, `ORDER BY`)

Once you can select data, the next step is to refine your selection. The `WHERE` clause filters rows based on a specified condition, and the `ORDER BY` clause sorts the result set.

  * **Filtering data with `WHERE`:**

    ```sql
    -- Find all employees with a salary greater than 40000
    SELECT EMPNO, FIRSTNME, LASTNAME, SALARY
    FROM EMPLOYEE
    WHERE SALARY > 40000;
    ```

    You can use various operators like `=`, `!=`, `>`, `<`, `>=`, `<=`, `IN`, and `BETWEEN` to filter your data.

  * **Sorting data with `ORDER BY`:**

    ```sql
    -- Order employees by salary, from highest to lowest
    SELECT EMPNO, FIRSTNME, LASTNAME, SALARY
    FROM EMPLOYEE
    ORDER BY SALARY DESC;
    ```

    You can sort by one or more columns in ascending (`ASC`) or descending (`DESC`) order.

### Aggregating Data (`GROUP BY`, `HAVING`)

ETL often involves summarizing or aggregating data before loading it into a target. `GROUP BY` is used to group rows that have the same values into summary rows, and aggregate functions (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`) perform calculations on these groups. The `HAVING` clause is used to filter these aggregated results.

  * **Grouping data by department:**

    ```sql
    -- Count the number of employees in each department
    SELECT WORKDEPT, COUNT(*) AS NUM_EMPLOYEES
    FROM EMPLOYEE
    GROUP BY WORKDEPT;
    ```

  * **Filtering grouped data with `HAVING`:**

    ```sql
    -- Find departments with more than 5 employees
    SELECT WORKDEPT, COUNT(*) AS NUM_EMPLOYEES
    FROM EMPLOYEE
    GROUP BY WORKDEPT
    HAVING COUNT(*) > 5;
    ```

    `HAVING` is to `GROUP BY` as `WHERE` is to `SELECT`. You use `HAVING` to filter on aggregate results, while `WHERE` filters on individual rows.

### Joins (`INNER`, `LEFT`, `RIGHT`, `FULL OUTER`)

This is arguably the most critical skill for ETL. Source data is rarely in a single table. You must combine data from multiple tables to create a comprehensive data set.

  * **Inner Join:** Returns rows when there is a match in **both** tables.

    ```sql
    -- Link employees to their departments
    SELECT E.EMPNO, E.FIRSTNME, E.LASTNAME, D.DEPTNAME
    FROM EMPLOYEE E
    INNER JOIN DEPARTMENT D ON E.WORKDEPT = D.DEPTNO;
    ```

    This is used when you only want to see data where a relationship exists in both source tables.

  * **Left Join:** Returns all rows from the **left** table, and the matched rows from the right table. The right side will have `NULL` values if there's no match. This is crucial for keeping all records from your primary source, even if they don't have a corresponding record in the other table.

    ```sql
    -- Get all departments and their employees, including departments with no employees
    SELECT D.DEPTNAME, E.FIRSTNME, E.LASTNAME
    FROM DEPARTMENT D
    LEFT JOIN EMPLOYEE E ON D.DEPTNO = E.WORKDEPT;
    ```

### Combining Result Sets (`UNION`, `UNION ALL`)

You'll sometimes need to combine the results of two or more `SELECT` statements.

  * **`UNION ALL`:** Appends the results of one query to another, including duplicates.

    ```sql
    -- Combine employee and staff names from two different tables
    SELECT FIRSTNME, LASTNAME FROM EMPLOYEE
    UNION ALL
    SELECT FIRSTNME, LASTNAME FROM EMP;
    ```

  * **`UNION`:** Appends results but **removes duplicate rows**. `UNION ALL` is generally faster and preferred in ETL unless you have a specific reason to eliminate duplicates within the combined dataset.

    ```sql
    -- Combine and show unique names from both tables
    SELECT FIRSTNME, LASTNAME FROM EMPLOYEE
    UNION
    SELECT FIRSTNME, LASTNAME FROM EMP;
    ```

## 2\. Data Definition Language (DDL)

While Data Manipulation Language (DML) focuses on the data within tables, Data Definition Language (DDL) is concerned with the structure of the database. DDL statements are used to create, modify, and delete database objects like tables, views, and indexes. In an ETL context, you'll use DDL to prepare your target schemas, create staging tables, and define data models.

### `CREATE`

The `CREATE` statement is used to create new database objects.

  * **Creating a table (`CREATE TABLE`)**: This is the most common DDL command in ETL. You use it to create the destination tables where your extracted data will be loaded.
    
    ```sql
    CREATE TABLE CLEAN_EMPLOYEE (
        EMP_ID INTEGER NOT NULL PRIMARY KEY,
        FULL_NAME VARCHAR(100),
        HIRE_DATE DATE,
        SALARY DECIMAL(10, 2),
        DEPARTMENT_NAME VARCHAR(50)
    );
    ```

    This defines the columns, their data types, and constraints like `NOT NULL` and `PRIMARY KEY`. Choosing the correct data types and constraints is vital for data integrity and performance.

  * **Creating an index (`CREATE INDEX`)**: Indexes are used to speed up data retrieval. You'll create them on columns that are frequently used in `JOIN` conditions or `WHERE` clauses in your queries.

    ```sql
    CREATE INDEX IDX_CLEAN_EMPLOYEE_NAME ON CLEAN_EMPLOYEE (FULL_NAME);
    ```

### `ALTER`

The `ALTER` statement is used to modify the structure of an existing database object. This is often necessary when your data source changes or you need to add new data points to your target tables.

  * **Adding a column**:

    ```sql
    ALTER TABLE CLEAN_EMPLOYEE
    ADD COLUMN BONUS DECIMAL(10, 2);
    ```

  * **Modifying a column**: You can change a column's data type, size, or constraints.

    ```sql
    ALTER TABLE CLEAN_EMPLOYEE
    ALTER COLUMN DEPARTMENT_NAME SET DATA TYPE VARCHAR(100);
    ```

    This is a common task when a data source provides longer values than initially expected.

  * **Dropping a column**:

    ```sql
    ALTER TABLE CLEAN_EMPLOYEE
    DROP COLUMN BONUS;
    ```

### `DROP`

The `DROP` statement is used to delete an existing database object completely. This is a powerful and irreversible command, so use it with caution. You might use it to remove old staging tables or to completely rebuild a data model.

  * **Dropping a table**:

    ```sql
    DROP TABLE CLEAN_EMPLOYEE;
    ```

  * **Dropping an index**:

    ```sql
    DROP INDEX IDX_CLEAN_EMPLOYEE_NAME;
    ```

### `TRUNCATE`

While `DROP` removes the table structure and its data, `TRUNCATE` is a DDL command that quickly removes all rows from a table, but leaves the structure intact. It's much faster than `DELETE` for mass deletions because it deallocates the data pages and logs the operation as a single transaction. It is often used in ETL to clear a staging table before loading new data.

  * **Truncating a table**:
    ```sql
    TRUNCATE TABLE STAGING_SALES_DATA;
    ```


That's an excellent catch. It seems my previous example had two issues:

1.  It used a single-line comment (`--`) within the string literal passed to the `db2` command, which is not valid syntax.
2.  The `INSERT` statement would have failed on the `NOT NULL` constraint for the `EDLEVEL` column, as seen in your error message. I apologize for that oversight.

Let's correct the examples and rewrite the DML section to be more accurate and helpful.

## 3\. Data Manipulation Language (DML)

While DDL (Data Definition Language) handles the structure of your database, **DML** (Data Manipulation Language) is all about interacting with the data itself. In an ETL context, DML commands are used to **extract**, **transform**, and **load** data.

### Inserting Data (`INSERT INTO`)

This is how you add new rows of data into a table. It's a foundational operation for any ETL process that loads data incrementally.

  * **Inserting a single row:** You must provide values for all columns that do not allow `NULL` values. Based on the `describe table employee` output, this includes `EMPNO`, `FIRSTNME`, `LASTNAME`, and `EDLEVEL`. My previous example missed `EDLEVEL`.

    ```sql
    INSERT INTO EMPLOYEE (EMPNO, FIRSTNME, LASTNAME, EDLEVEL, PHONENO, WORKDEPT)
    VALUES ('900001', 'JOHN', 'DOE', 16, '9999', 'E11');
    ```

    To execute this on the command line, it's best to put the SQL statement in a single line or use proper line continuation for readability, without comments inside the string literal. The `db2` command requires the entire statement to be a single string.

  * **Inserting multiple rows from another table:** This is a core ETL pattern. You can select data from a source table, perform transformations on the fly, and then insert the results into a target table.

    ```sql
    INSERT INTO EMPLOYEE (EMPNO, FIRSTNME, LASTNAME, EDLEVEL)
    SELECT
        S.EMP_ID,
        S.FIRST_NAME,
        S.LAST_NAME,
        S.EDUCATION_LEVEL
    FROM STAGING_EMPLOYEE S
    WHERE S.STATUS = 'ACTIVE';
    ```

    This demonstrates the importance of mapping and transforming data from a source schema to a target schema, ensuring all `NOT NULL` columns are provided with valid data.

### Updating Existing Data (`UPDATE`)

The `UPDATE` statement is used to modify data in existing rows. This is essential for **upsert** logic or for correcting data errors.

  * **Updating specific rows:** You must use a `WHERE` clause to specify which rows to update. Without it, you will update every row in the table.

    ```sql
    UPDATE EMPLOYEE
    SET SALARY = 155000.00, BONUS = 1500.00
    WHERE EMPNO = '000010';
    ```

  * **Updating based on a `JOIN`:** You can update a table using values from another table. This is often used to synchronize data between different systems or to fill in missing information.

    ```sql
    -- Update the `WORKDEPT` for employees whose job title is `PRES` in the `EMPLOYEE` table, using the `DEPARTMENT` table to find the correct department number.
    UPDATE EMPLOYEE E
    SET WORKDEPT = (SELECT D.DEPTNO FROM DEPARTMENT D WHERE D.DEPTNAME = 'INFORMATION CENTER')
    WHERE E.JOB = 'PRES';
    ```

    In this case, the `MGRNO` is the key to find the corresponding department in the `DEPARTMENT` table.

### Deleting Data (`DELETE FROM`)

The `DELETE` statement removes rows from a table. This is used in ETL to remove obsolete data, clean up staging tables, or handle historical records.

  * **Deleting specific rows:** Similar to `UPDATE`, the `WHERE` clause is critical to specify which rows to delete.

    ```sql
    DELETE FROM EMPLOYEE
    WHERE EMPNO = '900001';
    ```

  * **Deleting all rows:** To remove all data from a table, you can use `DELETE` without a `WHERE` clause.

    ```sql
    DELETE FROM SALES;
    ```

    **Note:** `TRUNCATE TABLE` (a DDL command) is much faster for this purpose, as it deallocates the data pages and doesn't log each individual row deletion. Use `DELETE` when you need to remove specific rows based on a condition.

### Bulk Loading Data (`LOAD FROM`)

For large-scale data ingestion, the standard `INSERT` statement is not efficient. DB2 provides the `LOAD FROM` command for high-speed, parallel data loading. This command is a powerful, low-level utility that bypasses the SQL engine's transactional logging, making it significantly faster for bulk operations. This is the cornerstone of the "Load" phase in ETL pipelines.

#### Creating and Loading a CSV File

To demonstrate, we will create a new CSV file with data for the `DEPARTMENT` table and then load it using a single command. The `echo` command is used here to create the file and add its contents in one step.

1.  **Create the data file:** Use `echo` with shell redirection to create a file named `new_departments.csv` and populate it with two new department records. The single quotes ensure the entire string, including the newline, is written as is.

    ```bash
    echo 'K01,"CUSTOMER SUPPORT",000100,A00,"NYC"
    L01,"SALES NORTH",-,A00,"CHICAGO"' > new_departments.csv
    ```

2.  **Run the `LOAD` command:** Use the `db2 LOAD` command to import the data from the newly created CSV file into the `DEPARTMENT` table.

    ```bash
    db2 "LOAD FROM 'new_departments.csv' OF DEL MODIFIED BY COLDEL, MESSAGES 'load.msg' INSERT INTO DEPARTMENT"
    
    Number of rows read         = 2
    Number of rows skipped      = 0
    Number of rows loaded       = 2
    Number of rows rejected     = 0
    Number of rows deleted      = 0
    Number of rows committed    = 2
    ```

      * **`FROM 'new_departments.csv'`**: Specifies the input file name. The file must be located in a path accessible by the DB2 instance.
      * **`OF DEL`**: The file is in a delimited ASCII format.
      * **`MODIFIED BY COLDEL,`**: The column delimiter is a comma.
      * **`MESSAGES 'load.msg'`**: Creates a log file to capture any errors, warnings, or detailed load information.
      * **`INSERT INTO DEPARTMENT`**: Appends the new data to the `DEPARTMENT` table. You can also use **`REPLACE`** to overwrite the existing data in the target table.

The `LOAD` utility is a critical tool for ETL engineers to handle large data volumes efficiently. After running the command, you can verify the new rows were added by querying the table.

<details><summary><code>load.msg</code></summary>

```
[db2inst1@02fbee59ef4e ~]$ cat load.msg 
SQL3109N  The utility is beginning to load data from file 
"/database/config/db2inst1/new_departments.csv".

SQL3500W  The utility is beginning the "LOAD" phase at time "08/31/2025 
07:29:57.000546".

SQL3519W  Begin Load Consistency Point. Input record count = "0".

SQL3520W  Load Consistency Point was successful.

SQL3110N  The utility has completed processing.  "2" rows were read from the 
input file.

SQL3519W  Begin Load Consistency Point. Input record count = "2".

SQL3520W  Load Consistency Point was successful.

SQL3515W  The utility has finished the "LOAD" phase at time "08/31/2025 
07:29:57.056543".

SQL3500W  The utility is beginning the "BUILD" phase at time "08/31/2025 
07:29:57.057193".

SQL3213I  The indexing mode is "REBUILD".

SQL3515W  The utility has finished the "BUILD" phase at time "08/31/2025 
07:29:57.095673".


Number of rows read         = 2
Number of rows skipped      = 0
Number of rows loaded       = 2
Number of rows rejected     = 0
Number of rows deleted      = 0
Number of rows committed    = 2
```

</details>
