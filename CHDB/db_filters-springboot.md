Operator | Meaning | SQL Equivalent | Example
eq | Equals | = | first_name = 'John'
neq | Not Equals | != | first_name != 'Alice'
gt | Greater Than | > | age > 18
lt | Less Than | < | age < 30
gte | Greater or Equal | >= | age >= 20
lte | Less or Equal | <= | age <= 25
like | Pattern match | LIKE | first_name LIKE '%Jo%'
ilike | Case-insensitive match | ILIKE (or LOWER() workaround) | LOWER(first_name) LIKE LOWER('%jo%')
in | Multiple values | IN (...) | course IN ('Math','Science')
nin | Not in | NOT IN (...) | course NOT IN ('History')
null | Is null | IS NULL | email IS NULL
nnull | Is not null | IS NOT NULL | email IS NOT NULL
btwn | Range (inclusive) | BETWEEN x AND y | age BETWEEN 18 AND 25
nbtwn | Not between | NOT BETWEEN x AND y | age NOT BETWEEN 30 AND 40
start | Starts with | LIKE 'value%' | first_name LIKE 'Jo%'
end | Ends with | LIKE '%value' | first_name LIKE '%hn'
cont | Contains substring | LIKE '%value%' | first_name LIKE '%oh%'
ncont | Does NOT contain | NOT LIKE '%value%' | first_name NOT LIKE '%oh%'
exists | Check if field exists (non-null) | IS NOT NULL | email EXISTS
notex | Check if field does not exist (is null) | IS NULL | phone_number NOT EXISTS
is | Check if field is (useful for boolean) | = | is_active IS TRUE
not | Check if field is not (useful for boolean) | != | is_active IS NOT TRUE
any | Any of the values | IN (...) | status IN ('Active', 'Pending', 'Completed')
has | Contains an element in array-like data | ARRAY_CONTAINS(...) | tags HAS 'Science'
nhas | Does NOT contain an element in array-like data | NOT ARRAY_CONTAINS(...) | tags NOT_HAS 'Math'
match | Full-text search (special case for ClickHouse) | MATCH | description MATCH 'Spring'
rregex | Match a regular expression | REGEXP | first_name REGEXP 'Jo.*'
nrregex | Does not match regular expression | NOT REGEXP | first_name NOT REGEXP '^J.*'
size | Match the size of array or string | LENGTH() or ARRAY_LENGTH() | tags SIZE 3
ltsize | Size less than | LENGTH() < x or ARRAY_LENGTH() < x | tags SIZE < 5
gtsize | Size greater than | LENGTH() > x or ARRAY_LENGTH() > x | tags SIZE > 2
