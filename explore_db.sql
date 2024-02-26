/*
    For psql db connection, use terminal command, IDE, or AWS JDK, etc.
    host, user, and password are shared in mentors' project document
    default psql port
*/

-- 1. But which database do we use?

SELECT * FROM pg_database;

-- It's glo


/*
See DB documentation, especially Design of the Database and Appendix A
For a db design overview, as well as table and field descriptions

Note:
dtrsco: a concatenation of range_dir, township, range, sec, corner_num, and obs_id.
*/

-- 2. What are the land survey observations?

-- observation
SELECT * FROM observations LIMIT 10;
SELECT COUNT(*) FROM observations;

-- corner observation
SELECT * FROM corner_obs LIMIT 10;
SELECT COUNT(*) FROM corner_obs;
SELECT COUNT(*)
FROM (
    SELECT DISTINCT dtrsco
    FROM corner_obs
) as cod;

-- line observation
SELECT * FROM line_obs LIMIT 10;
SELECT COUNT(*) FROM line_obs;

-- Looks like dtrsco is the primary key
-- So there are 309898 observations but only 309811 corner and lines observations

-- 3. What's missing?

SELECT COUNT(*)
FROM (
    SELECT dtrsco
    FROM corner_obs
    UNION
    SELECT dtrsco
    FROM line_obs
) AS cl_obs;

SELECT *
FROM observations AS obs
WHERE obs.dtrsco IN (
    SELECT dtrsco
    FROM observations
    EXCEPT (
        SELECT dtrsco
        FROM corner_obs
        UNION
        SELECT dtrsco
        FROM line_obs
    )
);

-- 4. Trees? Neat

SELECT * FROM witness_trees LIMIT 10;

SELECT COUNT(*) FROM witness_trees;

-- 5. More witness trees than observation? Does this include mounds?

SELECT COUNT(*)
FROM (
    SELECT DISTINCT dtrsco
    FROM witness_trees
) as wtd;

SELECT dtrsco, COUNT(*)
FROM witness_trees
GROUP BY dtrsco;

SELECT DISTINCT tree_id FROM witness_trees;

-- 184580 dtrsco with trees
-- Maybe there can be up to 4 trees per observation?

SELECT COUNT(*)
FROM witness_trees
WHERE sp = 'NL';

-- There are 2029 mounds

-- Provided sample query where observations are laid out :o
SELECT
	o.township as "Township", o.range as "Range", o.range_dir as "RangDir",
	o.point as "Point", o.point_dir as "PointDir", o.links as "Links",
	o.ptype as "Ptype", o.vegtype as "Vegtype", d.disturb as "Disturb",
	coalesce(d.inout, e.inout) as "Inout", m.mtype as "Mtype",
	coalesce(w1.sp, l.sp) as "Sp1", coalesce(w1.diam, l.diam) as "Diam1",
										w1.az as "Az1", w1.dist as "Dist1",
	w2.sp as "Sp2", w2.diam as "Diam2", w2.az as "Az2", w2.dist as "Dist2",
	w3.sp as "Sp3", w3.diam as "Diam3", w3.az as "Az3", w3.dist as "Dist3",
	w4.sp as "Sp4", w4.diam as "Diam4", w4.az as "Az4", w4.dist as "Dist4",
	o.fsp as "Fsp", o.usp as "Usp", o.surveyor as "Surveyor",
	o.survey_year as "Year", o.digitizer_id as "Initials",
	extract(month from o.digitization_date) as "Entermonth",
	extract(day from o.digitization_date) as "Enterday",
	extract(year from o.digitization_date) as "Enteryear",
	p.feature as "PointFeature", o.flag as "Flag", o.notes as "Notes",
	co.geom as geom
FROM observations as o
LEFT JOIN disturbances as d on o.dtrsco=d.dtrsco
LEFT JOIN ecosystems as e on o.dtrsco=e.dtrsco
LEFT JOIN meanders as m on o.dtrsco=m.dtrsco
LEFT JOIN line_trees as l on o.dtrsco=l.dtrsco
LEFT JOIN witness_trees as w1 on o.dtrsco=w1.dtrsco and w1.tree_id=1
LEFT JOIN witness_trees as w2 on o.dtrsco=w2.dtrsco and w2.tree_id=2
LEFT JOIN witness_trees as w3 on o.dtrsco=w3.dtrsco and w3.tree_id=3
LEFT JOIN witness_trees as w4 on o.dtrsco=w4.dtrsco and w4.tree_id=4
LEFT JOIN point_features as p on o.dtrsco=p.dtrsco
LEFT JOIN corner_obs as co on o.dtrsco=co.dtrsco;



