CREATE PROCEDURE [dbo].[GetItemPaths] 
    @TableName VARCHAR(50), 
    @NameField VARCHAR(50) = 'Name', 
    @HierarchyIDField VARCHAR(50) = 'HierarchyID'
AS 
BEGIN 
    DECLARE @SQL VARCHAR(MAX)
    SET @SQL = '
        WITH CTE AS (
            SELECT 
                [' + @HierarchyIDField + '], 
                CAST([' + @NameField + '] AS VARCHAR(MAX)) AS Path 
            FROM 
                [' + @TableName + '] 
            WHERE 
                [' + @HierarchyIDField + '].GetLevel() = 1 -- Starting from the root level
            UNION ALL
            SELECT 
                t.[' + @HierarchyIDField + '], 
                CONCAT(c.Path, ''/'', t.[' + @NameField + ']) AS Path
            FROM 
                [' + @TableName + '] t 
                INNER JOIN CTE c ON t.[' + @HierarchyIDField + '].GetAncestor(1) = c.[' + @HierarchyIDField + ']
        )
        SELECT 
            Path 
        FROM 
            CTE 
        ORDER BY 
            [' + @HierarchyIDField + ']'
    EXEC (@SQL)
END
