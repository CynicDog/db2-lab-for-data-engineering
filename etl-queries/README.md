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
