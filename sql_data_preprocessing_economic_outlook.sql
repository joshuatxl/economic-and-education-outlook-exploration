USE economic_outlook_schema;

/**Rename World Economic Outlook table*/
RENAME TABLE weo_data TO weo_master_table; 

/**Create region mapping table**/
ALTER TABLE weo_master_table 
DROP COLUMN `WEO Country Code`,
DROP COLUMN `WEO Subject Code`,
DROP COLUMN Units,
DROP COLUMN Scale,
DROP COLUMN `Estimates Start After`,
DROP COLUMN `2026`;

/**Create ISO-Region mapping table**/
CREATE TABLE iso_region_mapping (
	ISO VARCHAR(3) PRIMARY KEY,
    Region VARCHAR (50),
    Country VARCHAR(50)
);

/**Populate ISO-Region table**/
INSERT INTO iso_region_mapping (ISO, Region) VALUES

/** North America **/
('USA','North America'),
('CAN','North America'),

/** Latin America **/
('ARG','Latin America'),
('ATG','Latin America'),
('ABW','Latin America'),
('BHS','Latin America'),
('BRB','Latin America'),
('BLZ','Latin America'),
('BOL','Latin America'),
('BRA','Latin America'),
('CHL','Latin America'),
('COL','Latin America'),
('CRI','Latin America'),
('DOM','Latin America'),
('DMA','Latin America'),
('ECU','Latin America'),
('SLV','Latin America'),
('GRD','Latin America'),
('GTM','Latin America'),
('GUY','Latin America'),
('HTI','Latin America'),
('HND','Latin America'),
('JAM','Latin America'),
('MEX','Latin America'),
('NIC','Latin America'),
('PAN','Latin America'),
('PRY','Latin America'),
('PER','Latin America'),
('PRI','Latin America'),
('KNA','Latin America'),
('LCA','Latin America'),
('VCT','Latin America'),
('SUR','Latin America'),
('TTO','Latin America'),
('URY','Latin America'),
('VEN','Latin America'),

/** Europe **/
('ALB','Europe'),
('AND','Europe'),
('AUT','Europe'),
('BLR','Europe'),
('BEL','Europe'),
('BIH','Europe'),
('BGR','Europe'),
('HRV','Europe'),
('CYP','Europe'),
('CZE','Europe'),
('DNK','Europe'),
('EST','Europe'),
('FIN','Europe'),
('FRA','Europe'),
('GEO','Europe'),
('DEU','Europe'),
('GRC','Europe'),
('HUN','Europe'),
('ISL','Europe'),
('IRL','Europe'),
('ITA','Europe'),
('XKX','Europe'),
('LVA','Europe'),
('LTU','Europe'),
('LUX','Europe'),
('MLT','Europe'),
('MDA','Europe'),
('MNE','Europe'),
('NLD','Europe'),
('MKD','Europe'),
('NOR','Europe'),
('POL','Europe'),
('PRT','Europe'),
('ROU','Europe'),
('RUS','Europe'),
('SMR','Europe'),
('SRB','Europe'),
('SVK','Europe'),
('SVN','Europe'),
('ESP','Europe'),
('SWE','Europe'),
('CHE','Europe'),
('UKR','Europe'),
('GBR','Europe'),
('UVK','Europe'),

/** Asia Pacific **/
('AUS','Asia Pacific'),
('BGD','Asia Pacific'),
('BTN','Asia Pacific'),
('BRN','Asia Pacific'),
('KHM','Asia Pacific'),
('CHN','Asia Pacific'),
('FJI','Asia Pacific'),
('HKG','Asia Pacific'),
('IND','Asia Pacific'),
('IDN','Asia Pacific'),
('JPN','Asia Pacific'),
('KAZ','Asia Pacific'),
('KIR','Asia Pacific'),
('KOR','Asia Pacific'),
('KGZ','Asia Pacific'),
('LAO','Asia Pacific'),
('MAC','Asia Pacific'),
('FSM','Asia Pacific'),
('MHL','Asia Pacific'),
('MYS','Asia Pacific'),
('MDV','Asia Pacific'),
('MNG','Asia Pacific'),
('MMR','Asia Pacific'),
('NRU','Asia Pacific'),
('NPL','Asia Pacific'),
('NZL','Asia Pacific'),
('PAK','Asia Pacific'),
('PLW','Asia Pacific'),
('PNG','Asia Pacific'),
('PHL','Asia Pacific'),
('SGP','Asia Pacific'),
('WSM','Asia Pacific'),
('SLB','Asia Pacific'),
('LKA','Asia Pacific'),
('TWN','Asia Pacific'),
('TJK','Asia Pacific'),
('THA','Asia Pacific'),
('TLS','Asia Pacific'),
('TON','Asia Pacific'),
('TKM','Asia Pacific'),
('TUV','Asia Pacific'),
('UZB','Asia Pacific'),
('VUT','Asia Pacific'),
('VNM','Asia Pacific'),

/** Middle East **/
('AFG','Middle East'),
('ARM','Middle East'),
('AZE','Middle East'),
('BHR','Middle East'),
('IRN','Middle East'),
('IRQ','Middle East'),
('ISR','Middle East'),
('JOR','Middle East'),
('KWT','Middle East'),
('LBN','Middle East'),
('OMN','Middle East'),
('QAT','Middle East'),
('SAU','Middle East'),
('SYR','Middle East'),
('TUR','Middle East'),
('ARE','Middle East'),
('PSE','Middle East'),
('YEM','Middle East'),
('WBG','Middle East'),

/** Africa **/
('DZA','Africa'),
('AGO','Africa'),
('BEN','Africa'),
('BWA','Africa'),
('BFA','Africa'),
('BDI','Africa'),
('CPV','Africa'),
('CMR','Africa'),
('CAF','Africa'),
('TCD','Africa'),
('COM','Africa'),
('COD','Africa'),
('COG','Africa'),
('CIV','Africa'),
('DJI','Africa'),
('EGY','Africa'),
('GNQ','Africa'),
('ERI','Africa'),
('SWZ','Africa'),
('ETH','Africa'),
('GAB','Africa'),
('GMB','Africa'),
('GHA','Africa'),
('GIN','Africa'),
('GNB','Africa'),
('KEN','Africa'),
('LSO','Africa'),
('LBR','Africa'),
('LBY','Africa'),
('MDG','Africa'),
('MWI','Africa'),
('MLI','Africa'),
('MRT','Africa'),
('MUS','Africa'),
('MAR','Africa'),
('MOZ','Africa'),
('NAM','Africa'),
('NER','Africa'),
('NGA','Africa'),
('RWA','Africa'),
('SEN','Africa'),
('SYC','Africa'),
('SLE','Africa'),
('SOM','Africa'),
('ZAF','Africa'),
('STP','Africa'),
('SSD','Africa'),
('SDN','Africa'),
('TZA','Africa'),
('TGO','Africa'),
('TUN','Africa'),
('UGA','Africa'),
('ZMB','Africa'),
('ZWE','Africa');

SET SQL_SAFE_UPDATES = 0;

UPDATE iso_region_mapping a
LEFT JOIN weo_master_table b
	ON a.ISO = b.ISO
SET a.Country = b.Country;

/**Create Region column in weo_master_table and populate it based on iso_region_mapping**/
ALTER TABLE weo_master_table 
ADD COLUMN Region VARCHAR(50),
DROP COLUMN Country;

UPDATE weo_master_table a
LEFT JOIN iso_region_mapping b
	ON a.ISO = b.ISO
SET a.Region = COALESCE(b.Region, 'other');

/**Rearrange columns**/
ALTER TABLE weo_master_table
MODIFY Region VARCHAR(50) AFTER ISO;

/**Replace 'n/a' with NULL values**/
UPDATE weo_master_table
SET
    `1980` = NULLIF(`1980`, 'n/a'),
    `1981` = NULLIF(`1981`, 'n/a'),
    `1982` = NULLIF(`1982`, 'n/a'),
    `1983` = NULLIF(`1983`, 'n/a'),
    `1984` = NULLIF(`1984`, 'n/a'),
    `1985` = NULLIF(`1985`, 'n/a'),
    `1986` = NULLIF(`1986`, 'n/a'),
    `1987` = NULLIF(`1987`, 'n/a'),
    `1988` = NULLIF(`1988`, 'n/a'),
    `1989` = NULLIF(`1989`, 'n/a'),
    `1990` = NULLIF(`1990`, 'n/a'),
    `1991` = NULLIF(`1991`, 'n/a'),
    `1992` = NULLIF(`1992`, 'n/a'),
    `1993` = NULLIF(`1993`, 'n/a'),
    `1994` = NULLIF(`1994`, 'n/a'),
    `1995` = NULLIF(`1995`, 'n/a'),
    `1996` = NULLIF(`1996`, 'n/a'),
    `1997` = NULLIF(`1997`, 'n/a'),
    `1998` = NULLIF(`1998`, 'n/a'),
    `1999` = NULLIF(`1999`, 'n/a'),
    `2000` = NULLIF(`2000`, 'n/a'),
    `2001` = NULLIF(`2001`, 'n/a'),
    `2002` = NULLIF(`2002`, 'n/a'),
    `2003` = NULLIF(`2003`, 'n/a'),
    `2004` = NULLIF(`2004`, 'n/a'),
    `2005` = NULLIF(`2005`, 'n/a'),
    `2006` = NULLIF(`2006`, 'n/a'),
    `2007` = NULLIF(`2007`, 'n/a'),
    `2008` = NULLIF(`2008`, 'n/a'),
    `2009` = NULLIF(`2009`, 'n/a'),
    `2010` = NULLIF(`2010`, 'n/a'),
    `2011` = NULLIF(`2011`, 'n/a'),
    `2012` = NULLIF(`2012`, 'n/a'),
    `2013` = NULLIF(`2013`, 'n/a'),
    `2014` = NULLIF(`2014`, 'n/a'),
    `2015` = NULLIF(`2015`, 'n/a'),
    `2016` = NULLIF(`2016`, 'n/a'),
    `2017` = NULLIF(`2017`, 'n/a'),
    `2018` = NULLIF(`2018`, 'n/a'),
    `2019` = NULLIF(`2019`, 'n/a'),
    `2020` = NULLIF(`2020`, 'n/a'),
    `2021` = NULLIF(`2021`, 'n/a'),
    `2022` = NULLIF(`2022`, 'n/a'),
    `2023` = NULLIF(`2023`, 'n/a'),
    `2024` = NULLIF(`2024`, 'n/a'),
    `2025` = NULLIF(`2025`, 'n/a');
    
/**Remove ',' from values**/    
UPDATE weo_master_table
SET
    `1980` = REPLACE(`1980`, ',', ''),
    `1981` = REPLACE(`1981`, ',', ''),
    `1982` = REPLACE(`1982`, ',', ''),
    `1983` = REPLACE(`1983`, ',', ''),
    `1984` = REPLACE(`1984`, ',', ''),
    `1985` = REPLACE(`1985`, ',', ''),
    `1986` = REPLACE(`1986`, ',', ''),
    `1987` = REPLACE(`1987`, ',', ''),
    `1988` = REPLACE(`1988`, ',', ''),
    `1989` = REPLACE(`1989`, ',', ''),
    `1990` = REPLACE(`1990`, ',', ''),
    `1991` = REPLACE(`1991`, ',', ''),
    `1992` = REPLACE(`1992`, ',', ''),
    `1993` = REPLACE(`1993`, ',', ''),
    `1994` = REPLACE(`1994`, ',', ''),
    `1995` = REPLACE(`1995`, ',', ''),
    `1996` = REPLACE(`1996`, ',', ''),
    `1997` = REPLACE(`1997`, ',', ''),
    `1998` = REPLACE(`1998`, ',', ''),
    `1999` = REPLACE(`1999`, ',', ''),
    `2000` = REPLACE(`2000`, ',', ''),
    `2001` = REPLACE(`2001`, ',', ''),
    `2002` = REPLACE(`2002`, ',', ''),
    `2003` = REPLACE(`2003`, ',', ''),
    `2004` = REPLACE(`2004`, ',', ''),
    `2005` = REPLACE(`2005`, ',', ''),
    `2006` = REPLACE(`2006`, ',', ''),
    `2007` = REPLACE(`2007`, ',', ''),
    `2008` = REPLACE(`2008`, ',', ''),
    `2009` = REPLACE(`2009`, ',', ''),
    `2010` = REPLACE(`2010`, ',', ''),
    `2011` = REPLACE(`2011`, ',', ''),
    `2012` = REPLACE(`2012`, ',', ''),
    `2013` = REPLACE(`2013`, ',', ''),
    `2014` = REPLACE(`2014`, ',', ''),
    `2015` = REPLACE(`2015`, ',', ''),
    `2016` = REPLACE(`2016`, ',', ''),
    `2017` = REPLACE(`2017`, ',', ''),
    `2018` = REPLACE(`2018`, ',', ''),
    `2019` = REPLACE(`2019`, ',', ''),
    `2020` = REPLACE(`2020`, ',', ''),
    `2021` = REPLACE(`2021`, ',', ''),
    `2022` = REPLACE(`2022`, ',', ''),
    `2023` = REPLACE(`2023`, ',', ''),
    `2024` = REPLACE(`2024`, ',', ''),
    `2025` = REPLACE(`2025`, ',', '');

SET SQL_SAFE_UPDATES = 1;

/**Change data types**/
ALTER TABLE weo_master_table
MODIFY ISO VARCHAR(10),
MODIFY `Subject Descriptor` VARCHAR(50),
MODIFY `1980` FLOAT,
MODIFY `1981` FLOAT,
MODIFY `1982` FLOAT,
MODIFY `1983` FLOAT,
MODIFY `1984` FLOAT,
MODIFY `1985` FLOAT,
MODIFY `1986` FLOAT,
MODIFY `1987` FLOAT,
MODIFY `1988` FLOAT,
MODIFY `1989` FLOAT,
MODIFY `1990` FLOAT,
MODIFY `1991` FLOAT,
MODIFY `1992` FLOAT,
MODIFY `1993` FLOAT,
MODIFY `1994` FLOAT,
MODIFY `1995` FLOAT,
MODIFY `1996` FLOAT,
MODIFY `1997` FLOAT,
MODIFY `1998` FLOAT,
MODIFY `1999` FLOAT,
MODIFY `2000` FLOAT,
MODIFY `2001` FLOAT,
MODIFY `2002` FLOAT,
MODIFY `2003` FLOAT,
MODIFY `2004` FLOAT,
MODIFY `2005` FLOAT,
MODIFY `2006` FLOAT,
MODIFY `2007` FLOAT,
MODIFY `2008` FLOAT,
MODIFY `2009` FLOAT,
MODIFY `2010` FLOAT,
MODIFY `2011` FLOAT,
MODIFY `2012` FLOAT,
MODIFY `2013` FLOAT,
MODIFY `2014` FLOAT,
MODIFY `2015` FLOAT,
MODIFY `2016` FLOAT,
MODIFY `2017` FLOAT,
MODIFY `2018` FLOAT,
MODIFY `2019` FLOAT,
MODIFY `2020` FLOAT,
MODIFY `2021` FLOAT,
MODIFY `2022` FLOAT,
MODIFY `2023` FLOAT,
MODIFY `2024` FLOAT,
MODIFY `2025` FLOAT;

/**Create table for GDP; Drop Subject Descriptor column; Make ISO the primary key**/
CREATE TABLE gdp_country AS
SELECT
	*
FROM weo_master_table
	WHERE `Subject Descriptor` = 'Gross domestic product, current prices';
    
ALTER TABLE gdp_country
DROP COLUMN `Subject Descriptor`;

ALTER TABLE gdp_country
ADD PRIMARY KEY (ISO);

/**Create table for GDP per capita; Drop Subject Descriptor column; Make ISO the primary key**/
CREATE TABLE gdp_percap_country AS
SELECT
	*
FROM weo_master_table
	WHERE `Subject Descriptor` = 'Gross domestic product per capita, current prices';
    
ALTER TABLE gdp_percap_country
DROP COLUMN `Subject Descriptor`;

ALTER TABLE gdp_percap_country
ADD PRIMARY KEY (ISO);

/**Create table for population; Drop Subject Descriptor column; Make ISO the primary key**/
CREATE TABLE population_country AS
SELECT
	*
FROM weo_master_table
	WHERE `Subject Descriptor` = 'Population';
    
ALTER TABLE population_country
DROP COLUMN `Subject Descriptor`;

ALTER TABLE population_country
ADD PRIMARY KEY (ISO);

/**Create table for Africa; Drop Region column **/
CREATE TABLE gdp_africa AS
SELECT 
	*
FROM gdp_country
	WHERE Region = 'Africa';

ALTER TABLE gdp_africa
DROP COLUMN Region;

/**Create table for Asia Pacific; Drop Region column **/
CREATE TABLE gdp_apac AS
SELECT 
	*
FROM gdp_country
	WHERE Region = 'Asia Pacific';

ALTER TABLE gdp_apac
DROP COLUMN Region;

/**Create table for Europe; Drop Region column**/
CREATE TABLE gdp_europe AS
SELECT
	* 
FROM gdp_country
	WHERE Region = 'Europe';

ALTER TABLE gdp_europe
DROP COLUMN Region;

/**Create table for Latin America**/
CREATE TABLE gdp_latam AS
SELECT 
	* 
FROM gdp_country
	WHERE Region = 'Latin America';

ALTER TABLE gdp_latam 
DROP COLUMN Region;

/**Create table for Middle East**/
CREATE TABLE gdp_me
SELECT
	*
FROM gdp_country
	WHERE Region = 'Middle East';

ALTER TABLE gdp_me
DROP COLUMN Region;

/**Create table for North America**/
CREATE TABLE gdp_na
SELECT
	*
FROM gdp_country
	WHERE Region = 'North America';
    
ALTER TABLE gdp_na
DROP COLUMN Region;

/**Make ISO primary key for all region GDP tables**/
ALTER TABLE gdp_africa
ADD PRIMARY KEY (ISO);

ALTER TABLE gdp_apac
ADD PRIMARY KEY (ISO);

ALTER TABLE gdp_europe
ADD PRIMARY KEY (ISO);

ALTER TABLE gdp_latam
ADD PRIMARY KEY (ISO);

ALTER TABLE gdp_me
ADD PRIMARY KEY (ISO);

ALTER TABLE gdp_na
ADD PRIMARY KEY (ISO);

SELECT * FROM iso_region_mapping LIMIT 5;

/**Identify countries with invalid characters in iso_region_mapping**/
SELECT
	DISTINCT Country
FROM iso_region_mapping
WHERE Country REGEXP '[^A-Za-z -.]';

/**Rename countries with invalid characters**/
START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;

UPDATE iso_region_mapping
SET Country = CASE
	WHEN Country = 'CÃ´te d''Ivoire' THEN 'Ivory Coast'
    WHEN Country = 'SÃ£o TomÃ© and PrÃ­ncipe' THEN 'São Tomé and Príncipe'
    WHEN Country = 'TÃ¼rkiye' THEN 'Türkiye'
    ELSE Country
    END;
    
SET SQL_SAFE_UPDATES = 1;

/**Create table for Employment**/
CREATE TABLE employment_country AS
SELECT
	*
FROM weo_master_table
	WHERE `Subject Descriptor` = 'Employment';
    
/**Create table for Unemployment rate**/    
CREATE TABLE unemployment_rate_country AS
SELECT
	*
FROM weo_master_table
	WHERE `Subject Descriptor` = 'Unemployment rate';