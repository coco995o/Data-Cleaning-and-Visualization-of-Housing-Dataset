CREATE TABLE IF NOT EXISTS h1 (
	uniqueid integer,
	parcelid varchar,
	landuse varchar,
	propertyaddress text,
	saledate date,
	saleprice varchar,
	legalreference varchar,
	soldasvacant varchar,
	ownername text,
	owneraddress text,
	acreage numeric,
	taxdistrict varchar,
	landvalue numeric,
	buildingvalue numeric,
	totalvalue numeric,
	yearbuilt integer,
	bedrooms integer,
	fullbath integer,
	halfbath integer
);

SELECT propertyaddress, REGEXP_REPLACE(propertyaddress, '\s+',' ','g')
FROM h1;

UPDATE h1
SET propertyaddress = REGEXP_REPLACE(propertyaddress, '\s+',' ','g');

SELECT owneraddress, REGEXP_REPLACE(owneraddress,'\s+',' ', 'g') FROM h1;

UPDATE h1
SET owneraddress = REGEXP_REPLACE(owneraddress,'\s+',' ', 'g');

SELECT propertyaddress || ', TN', 
		owneraddress,
		(propertyaddress || ', TN' = owneraddress)
FROM h1
WHERE owneraddress IS NOT NULL;

WITH cte AS (
SELECT h.propertyaddress AS paddress, h2.owneraddress AS oaddress, h.uniqueid
FROM h1 AS h
LEFT JOIN h1 AS h2
ON h.uniqueid = h2.uniqueid
)

UPDATE h1
SET owneraddress = cte.paddress
FROM cte
WHERE h1.uniqueid = cte.uniqueid
	AND propertyaddress IS NOT NULL
		AND owneraddress IS NULL;

SELECT * FROM h1
WHERE propertyaddress IS NULL
ORDER BY parcelid;

SELECT owneraddress, owneraddress || ', TN', LENGTH(owneraddress), LENGTH(owneraddress || ', TN')
FROM h1
WHERE owneraddress NOT LIKE '%, TN';

UPDATE h1
SET owneraddress = owneraddress || ', TN'
WHERE owneraddress NOT LIKE '%, TN';

SELECT * FROM h1
WHERE propertyaddress IS NULL;

--ALTER TABLE h1
--ADD COLUMN propertyaddress1 text;

SELECT owneraddress, LEFT(owneraddress, -4) FROM h1;

--UPDATE h1
--SET propertyaddress1 = LEFT(owneraddress, -4);

SELECT * FROM h1
WHERE propertyaddress IS NULL;

/*UPDATE h1
SET propertyaddress = propertyaddress1
WHERE propertyaddress IS NULL
	AND owneraddress IS NOT NULL;*/

UPDATE h1
SET propertyaddress = 'N/A',
	owneraddress = 'N/A'
WHERE propertyaddress IS NULL
	AND owneraddress IS NULL;
	
SELECT owneraddress, propertyaddress FROM h1
WHERE owneraddress LIKE 'N/A, TN';

UPDATE h1
SET owneraddress = 'N/A'
WHERE owneraddress = 'N/A, TN';

SELECT * FROM h1;

UPDATE h1
SET soldasvacant = 'No'
WHERE soldasvacant LIKE 'N%';

SELECT * FROM h1
WHERE soldasvacant <> 'Yes'
	AND soldasvacant <> 'No';

UPDATE h1
SET soldasvacant = 'Yes'
WHERE soldasvacant = 'Y';

SELECT * FROM h1;

UPDATE h1
SET ownername = 'Unknown'
WHERE ownername IS NULL;

UPDATE h1
SET taxdistrict = 'N/A'
WHERE taxdistrict IS NULL;

SELECT * FROM h1;

UPDATE h1
SET acreage = COALESCE(acreage, 0),
    landvalue = COALESCE(landvalue, 0),
    buildingvalue = COALESCE(buildingvalue, 0),
    totalvalue = COALESCE(totalvalue, 0),
    yearbuilt = COALESCE(yearbuilt, 0),
    bedrooms = COALESCE(bedrooms, 0),
    fullbath = COALESCE(fullbath, 0),
    halfbath = COALESCE(halfbath, 0)
WHERE acreage IS NULL 
   OR landvalue IS NULL 
   OR buildingvalue IS NULL 
   OR totalvalue IS NULL 
   OR yearbuilt IS NULL 
   OR bedrooms IS NULL 
   OR fullbath IS NULL 
   OR halfbath IS NULL;

SELECT * FROM h1
ORDER BY uniqueid;

--ALTER TABLE h1
--DROP COLUMN propertyaddress1

SELECT * FROM h1
ORDER BY uniqueid;

WITH cte AS (
	SELECT *,
	ROW_NUMBER() OVER(PARTITION BY parcelid,landuse,propertyaddress,saledate,saleprice,legalreference,soldasvacant,ownername,owneraddress,acreage,taxdistrict,landvalue,buildingvalue,totalvalue,yearbuilt,bedrooms,fullbath,halfbath) AS row_id
	FROM h1
)

DELETE FROM h1
WHERE uniqueid IN (
	SELECT uniqueid FROM cte
	WHERE row_id = 2
);

SELECT * FROM h1
ORDER BY uniqueid
