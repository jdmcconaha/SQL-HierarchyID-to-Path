# GetItemPaths Stored Procedure

The GetItemPaths stored procedure returns the hierarchical paths of items in a specified table by traversing a hierarchyid column.


## Example
A table with the following records:
|Id|Name|HierarchyID
|--|----|-----------
|1|	CEO	| /1/
|2|	CFO	| /1/2/
|3|	CTO	| /1/3/
|4|	Manager| /1/2/4/
|5|	Developer| /1/3/5/
|6|	Designer| /1/3/6/

Will return:
|Path
|----
|CEO
|CEO/CFO
|CEO/CFO/Manager
|CEO/CTO
|CEO/CTO/Developer
|CEO/CTO/Designer


## Parameters
@TableName: A string value that specifies the name of the table containing the items to retrieve.
@NameField (optional): A string value that specifies the name of the field in the table containing the item names. The default value is 'Name'.
@HierarchyIDField (optional): A string value that specifies the name of the hierarchyid field in the table. The default value is 'HierarchyID'.

## Usage
To use the stored procedure, specify the required parameters and execute it as follows:

```SQL
EXEC [dbo].[GetItemPaths] 
    @TableName = 'Items', 
    @NameField = 'Name', 
    @HierarchyIDField = 'HierarchyID'
```

This will return a result set containing the hierarchical paths of each item in the Items table based on their location in the hierarchy.

##Implementation Details
The stored procedure uses a common table expression (CTE) to recursively traverse the hierarchy tree and build the paths of each item.

The initial query selects only the root level nodes by filtering on the GetLevel() method of the hierarchyid column.

The recursive part of the CTE joins the table with the results of the previous recursive iteration, generating the full path for each item by concatenating its name with the parent node's path using the GetAncestor() method of the hierarchyid column.

Finally, the top-level CTE query simply selects the resulting paths from the CTE in hierarchical order based on the hierarchyid values.

The entire SQL query is constructed dynamically within the stored procedure using the provided parameter values and executed using the EXEC statement, allowing for flexibility in specifying different table or column names at runtime.
