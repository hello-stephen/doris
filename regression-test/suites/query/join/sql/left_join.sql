SELECT a.column_31
FROM table1 AS a
  LEFT JOIN table2 AS g ON g.column_1=a.column_3
  LEFT JOIN table3 AS h ON h.column_3=a.column_2
  LEFT JOIN table4 AS p ON p.column_2=a.column_87
  LEFT JOIN table5 AS s ON s.column_6=g.column_97 AND g.column_97 > 1
WHERE a.column_66=0 
  AND (CASE WHEN a.column_61>0 AND a.column_87>0 THEN 1 WHEN a.column_61=0 THEN 1 ELSE 0 END)=1 
  AND h.column_69 not in (3,5) 
  AND IF(a.column_46=1,a.column_34,IF(a.column_87>0,p.column_1,a.column_1)) >= "2021-06-01"
  AND IF(a.column_46=1,a.column_34,IF(a.column_87>0,p.column_1,a.column_1)) < "2021-07-01"
  AND a.column_74=0 
  AND a.column_71 in (0,2) 
ORDER BY a.column_31 ASC;


SELECT a.column_31
FROM table1 AS a
  LEFT JOIN table2 AS g ON g.column_1=a.column_3
  LEFT JOIN table3 AS h ON h.column_3=a.column_2
  LEFT JOIN table4 AS p ON p.column_2=a.column_87
  LEFT JOIN table5 AS s ON s.column_6=g.column_97 AND g.column_97 > 1
WHERE a.column_66=0 ;

SELECT a.column_31, a.column_3, g.column_1
FROM table1 AS a
  LEFT JOIN table2 AS g ON g.column_1=a.column_3
  LEFT JOIN table3 AS h ON h.column_3=a.column_2
  LEFT JOIN table4 AS p ON p.column_2=a.column_87
  LEFT JOIN table5 AS s ON s.column_6=g.column_97
WHERE a.column_66=0 ;

SELECT a.column_31, a.column_3, g.column_1
FROM table1 AS a
  LEFT JOIN table2 AS g ON g.column_1=a.column_3
  LEFT JOIN table3 AS h ON h.column_3=a.column_2
  LEFT JOIN table4 AS p ON p.column_2=a.column_87
  LEFT JOIN table5 AS s ON s.column_6=g.column_97 and s.column_6 > 1
WHERE a.column_66=0 ;


SELECT a.column_31, a.column_3, g.column_1
FROM table1 AS a
  LEFT JOIN table2 AS g ON g.column_1=a.column_3
WHERE a.column_66=0 ;

SELECT a.column_31, a.column_3, g.column_1, a.column_2, h.column_3
FROM table1 AS a
  LEFT JOIN table2 AS g ON g.column_1=a.column_3
  LEFT JOIN table3 AS h ON h.column_3=a.column_2
WHERE a.column_66=0 ;

SELECT a.column_31, a.column_66, a.column_2, h.column_3
FROM table1 AS a
  LEFT JOIN table3 AS h ON h.column_3=a.column_2 
WHERE a.column_66=0 ;

SELECT a.column_31, a.column_66, a.column_2, h.column_3
FROM table1 AS a
  LEFT JOIN table3 AS h ON h.column_3=a.column_2 and a.column_2>1
WHERE a.column_66=0 ;

SELECT a.column_66, a.column_2, h.column_3
FROM table1 AS a
  LEFT JOIN table3 AS h ON h.column_3=a.column_2 and a.column_2=1369319
WHERE a.column_66=0 ;

SELECT a.column_66, a.column_2, h.column_3
FROM table1 AS a
  LEFT JOIN table3 AS h ON h.column_3=a.column_2 and h.column_3=1369319
WHERE a.column_66=0 ;

