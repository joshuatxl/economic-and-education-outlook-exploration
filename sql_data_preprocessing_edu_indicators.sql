USE economic_outlook_schema;

/**Rename table 'data' to 'edu_indctr'**/
RENAME TABLE `data` TO edu_indctr;

/**Drop qualifier and magnitude columns**/
ALTER TABLE edu_indctr
DROP COLUMN qualifier,
DROP COLUMN magnitude,
RENAME COLUMN geoUnit TO ISO,
RENAME COLUMN indicatorId TO Indicator,
MODIFY `value` FLOAT,
ADD COLUMN Region VARCHAR(50);

SET SQL_SAFE_UPDATES = 0;

/**Replace Indicator column values with indicator names**/
UPDATE edu_indctr
SET Indicator = 
CASE 
	WHEN Indicator = 'GAR.5T8' THEN 'Gross Attendance Ratio'
    WHEN Indicator = 'GER.5T8' THEN 'Gross Enrolment Ratio'
    WHEN Indicator = 'GGR.6T7' THEN 'Gross Graduation Ratio'
    WHEN Indicator = 'PRYA.12MO.AG15T64' THEN 'Adult Participation Rate'
	END;

/**Map regions to ISOs**/    
UPDATE edu_indctr a
LEFT JOIN iso_region_mapping b
	ON a.ISO = b.ISO
SET a.Region = COALESCE(b.Region, 'other');

/**Rearrange columns**/  
ALTER TABLE edu_indctr
MODIFY Region VARCHAR(50) AFTER ISO;

/**Remove invalid values in the ISO column**/
DELETE FROM edu_indctr
WHERE CHAR_LENGTH(ISO) > 3;

/**Remove countries that don't appear in weo_master_table. The list of countries in weo_master_table will serve as the reference list of analysis, of which the region mapping dictionary is based on**/
DELETE FROM edu_indctr
WHERE Region = 'other';

SET SQL_SAFE_UPDATES = 1;

/**Create tables for Gross Attendance Ratio, Gross Enrolment Ratio, Gross Graduation Ratio; Adult Participation Ratio excluded from analysis**/
CREATE TABLE gar_country AS
SELECT 
	*
FROM edu_indctr
	WHERE Indicator = 'Gross Attendance Ratio';
    
CREATE TABLE ger_country AS
SELECT 
	*
FROM edu_indctr
	WHERE Indicator = 'Gross Enrolment Ratio';

CREATE TABLE ggr_country AS
SELECT 
	*
FROM edu_indctr
	WHERE Indicator = 'Gross Graduation Ratio';
    
CREATE TABLE apr_country AS
SELECT 
	*
FROM edu_indctr
	WHERE Indicator = 'Adult Participation Rate';

/**Drop Indicator columns**/
ALTER TABLE gar_country
DROP COLUMN Indicator;

ALTER TABLE ger_country
DROP COLUMN Indicator;

ALTER TABLE ggr_country
DROP COLUMN Indicator;

ALTER TABLE apr_country
DROP COLUMN Indicator;


