unit uibkeywords;

interface

uses
  SysUtils;

const
  SQLToKens : array[0..326] of String = (
    'ABS', 'ACCENT', 'ACOS', 'ACTION', 'ACTIVE', 'ADD', 'ADMIN', 'AFTER', 'ALL',
    'ALTER', 'ALWAYS', 'AND', 'ANY', 'AS', 'ASC', 'ASCENDING', 'ASCII_CHAR',
    'ASCII_VAL', 'ASIN', 'AT', 'ATAN', 'ATAN2', 'AUTO', 'AVG', 'BACKUP',
    'BEFORE', 'BEGIN', 'BETWEEN', 'BIGINT', 'BIN_AND', 'BIN_OR', 'BIN_SHL',
    'BIN_SHR', 'BIN_XOR', 'BIT_LENGTH', 'BLOB', 'BLOCK', 'BOTH', 'BREAK', 'BY',
    'CASCADE', 'CASE', 'CAST', 'CEIL', 'CEILING', 'CHAR', 'CHAR_LENGTH',
    'CHARACTER', 'CHARACTER_LENGTH', 'CHECK', 'CLOSE', 'COALESCE', 'COLLATE',
    'COLLATION', 'COLUMN', 'COMMENT', 'COMMIT', 'COMMITTED', 'COMPUTED',
    'CONDITIONAL', 'CONNECT', 'CONSTRAINT', 'CONTAINING', 'COS', 'COSH', 'COT',
    'COUNT', 'CREATE', 'CROSS', 'CSTRING', 'CURRENT', 'CURRENT_CONNECTION',
    'CURRENT_DATE', 'CURRENT_ROLE', 'CURRENT_TIME', 'CURRENT_TIMESTAMP',
    'CURRENT_TRANSACTION', 'CURRENT_USER', 'CURSOR', 'DATABASE', 'DATE',
    'DATEADD', 'DATEDIFF', 'DAY', 'DEBUG', 'DEC', 'DECIMAL', 'DECLARE', 'DECODE',
    'DEFAULT', 'DELETE', 'DELETING', 'DESC', 'DESCENDING', 'DESCRIPTOR',
    'DIFFERENCE', 'DISCONNECT', 'DISTINCT', 'DO', 'DOMAIN', 'DOUBLE', 'DROP',
    'ELSE', 'END', 'ENTRY_POINT', 'ESCAPE', 'EXCEPTION', 'EXECUTE', 'EXISTS',
    'EXIT', 'EXP', 'EXTERNAL', 'EXTRACT', 'FETCH', 'FILE', 'FILTER', 'FIRST',
    'FLOAT', 'FLOOR', 'FOR', 'FOREIGN', 'FREE_IT', 'FROM', 'FULL', 'FUNCTION',
    'GDSCODE', 'GENERATED', 'GENERATOR', 'GEN_ID', 'GEN_UUID', 'GLOBAL', 'GRANT',
    'GROUP', 'HASH', 'HAVING', 'HOUR', 'IF', 'IGNORE', 'IIF', 'IN', 'INACTIVE',
    'INDEX', 'INNER', 'INPUT_TYPE', 'INSENSITIVE', 'INSERT', 'INSERTING', 'INT',
    'INTEGER', 'INTO', 'IS', 'ISOLATION', 'JOIN', 'KEY', 'LAST', 'LEADING',
    'LEAVE', 'LEFT', 'LENGTH', 'LEVEL', 'LIKE', 'LIMBO', 'LIST', 'LN', 'LOCK',
    'LOG', 'LOG10', 'LONG', 'LOWER', 'LPAD', 'MANUAL', 'MATCHED', 'MATCHING',
    'MAX', 'MAXVALUE', 'MAXIMUM_SEGMENT', 'MERGE', 'MILLISECOND', 'MIN', 'MINUTE',
    'MINVALUE', 'MOD', 'MODULE_NAME', 'MONTH', 'NAMES', 'NATIONAL', 'NATURAL',
    'NCHAR', 'NEXT', 'NO', 'NOT', 'NULLIF', 'NULL', 'NULLS', 'NUMERIC',
    'OCTET_LENGTH', 'OF', 'ON', 'ONLY', 'OPEN', 'OPTION', 'OR', 'ORDER', 'OUTER',
    'OUTPUT_TYPE', 'OVERFLOW', 'OVERLAY', 'PAD', 'PAGE', 'PAGES', 'PAGE_SIZE',
    'PARAMETER', 'PASSWORD', 'PI', 'PLACING', 'PLAN', 'POSITION', 'POST_EVENT',
    'POWER', 'PRECISION', 'PRESERVE', 'PRIMARY', 'PRIVILEGES', 'PROCEDURE',
    'PROTECTED', 'RAND', 'RDB$DB_KEY', 'READ', 'REAL', 'RECORD_VERSION',
    'RECREATE', 'RECURSIVE', 'REFERENCES', 'RELEASE', 'REPLACE', 'REQUESTS',
    'RESERV', 'RESERVING', 'RESTART', 'RESTRICT', 'RETAIN', 'RETURNING',
    'RETURNING_VALUES', 'RETURNS', 'REVERSE', 'REVOKE', 'RIGHT', 'ROLE',
    'ROLLBACK', 'ROUND', 'ROW_COUNT', 'ROWS', 'RPAD', 'SAVEPOINT', 'SCALAR_ARRAY',
    'SCHEMA', 'SECOND', 'SEGMENT', 'SELECT', 'SENSITIVE', 'SEQUENCE', 'SET',
    'SHADOW', 'SHARED', 'SIGN', 'SIN', 'SINGULAR', 'SINH', 'SIZE', 'SKIP',
    'SMALLINT', 'SNAPSHOT', 'SOME', 'SORT', 'SPACE', 'SQLCODE', 'SQRT',
    'STABILITY', 'START', 'STARTING', 'STARTS', 'STATEMENT', 'STATISTICS',
    'SUBSTRING', 'SUB_TYPE', 'SUM', 'SUSPEND', 'TABLE', 'TAN', 'TANH',
    'TEMPORARY', 'THEN', 'TIME', 'TIMESTAMP', 'TIMEOUT', 'TO', 'TRAILING',
    'TRANSACTION', 'TRIGGER', 'TRIM', 'TRUNC', 'UNCOMMITTED', 'UNDO',
    'UNION', 'UNIQUE', 'UPDATE', 'UPDATING', 'UPPER', 'USER', 'USING', 'VALUE',
    'VALUES', 'VARCHAR', 'VARIABLE', 'VARYING', 'VIEW', 'WAIT', 'WEEK',
    'WEEKDAY', 'WHEN', 'WHERE', 'WHILE', 'WITH', 'WORK', 'WRITE', 'YEAR',
    'YEARDAY');

implementation

end.
