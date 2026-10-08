USE economic_outlook_schema;

/**Drop redundant columns; rename Location code to Country; make Index Primary Key**/
ALTER TABLE uni_rank_2025
DROP COLUMN Location,
RENAME COLUMN `Location code` TO Country,
ADD PRIMARY KEY (`Index`);

/**Assign one rank for 2025 and 2024 to each university - the higher rank if a the rank is a range, removing '+'**/
START TRANSACTION;
SAVEPOINT sp1;
SET SQL_SAFE_UPDATES = 0;

UPDATE uni_rank_2025
SET
	`2025 rank`  = LEFT(`2025 rank`, 4),
	`2025 rank`  = REGEXP_REPLACE(`2025 rank`, '[+-]', '');
SAVEPOINT sp2;
    
UPDATE uni_rank_2025
SET
	`2024 rank`  = LEFT(`2024 rank`, 4),
	`2024 rank`  = REGEXP_REPLACE(`2024 rank`, '[+-]', '');
SAVEPOINT sp3;

UPDATE uni_rank_2025
SET 
	`Ar rank` = REGEXP_REPLACE(`Ar rank`, '[+=]', ''),
    `Er rank` = REGEXP_REPLACE(`Ar rank`, '[+=]', ''),
    `Fsr rank` = REGEXP_REPLACE(`Ar rank`, '[+=]', ''),
    `Cpf rank` = REGEXP_REPLACE(`Ar rank`, '[+=]', ''),
    `Ifr rank` = REGEXP_REPLACE(`Ar rank`, '[+=]', ''),
    `Isr rank` = REGEXP_REPLACE(`Ar rank`, '[+=]', ''),
    `Irn rank` = REGEXP_REPLACE(`Ar rank`, '[+=]', ''),
    `Ger rank` = REGEXP_REPLACE(`Ar rank`, '[+=]', ''),
    `Sus rank` = REGEXP_REPLACE(`Ar rank`, '[+=]', '');
    
/**Update column data types**/

ALTER TABLE uni_rank_2025
MODIFY COLUMN `2025 rank` FLOAT,
MODIFY COLUMN `2024 rank` FLOAT,
MODIFY COLUMN `Ar score` FLOAT,
MODIFY COLUMN `Ar rank` INT,
MODIFY COLUMN `Er score` FLOAT,
MODIFY COLUMN `Er rank` INT,
MODIFY COLUMN `Fsr score` FLOAT,
MODIFY COLUMN `Fsr rank` INT,
MODIFY COLUMN `Cpf score` FLOAT,
MODIFY COLUMN `Cpf rank` INT,
MODIFY COLUMN `Ifr score` FLOAT,
MODIFY COLUMN `Ifr rank` INT,
MODIFY COLUMN `Isr score` FLOAT,
MODIFY COLUMN `Isr rank` INT,
MODIFY COLUMN `Irn score` FLOAT,
MODIFY COLUMN `Irn rank` INT,
MODIFY COLUMN `Ger score` FLOAT,
MODIFY COLUMN `Ger rank` INT,
MODIFY COLUMN `Sus score` FLOAT,
MODIFY COLUMN `Sus rank` INT; 


/**Identify countries non-matching countries between uni_rank_2025 and iso_region_mapping**/
SELECT
	a.Country,
    b.Country
FROM uni_rank_2025 a
	LEFT JOIN iso_region_mapping b ON a.Country = b.Country
WHERE b.Country IS NULL
GROUP BY 
	a.Country,
    b.Country;
    
/**Rename countries on this dataset, rename Turkiye and other countries with weird caharcters on other weo dataset**/
 
START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;
SAVEPOINT sp4;

UPDATE uni_rank_2025
SET Country = CASE
	WHEN Country = 'China (Mainland)' THEN 'China'
    WHEN Country = 'South Korea' THEN 'Korea'
    WHEN Country = 'Taiwan' THEN 'Taiwan Province of China'
    WHEN Country = 'Macau SAR' THEN 'Macao SAR'
    WHEN Country = 'Turkey' THEN 'Türkiye' 
    WHEN Country = 'Iran, Islamic Republic of' THEN 'Islamic Republic of Iran'
	WHEN Country = 'Brunei' THEN 'Brunei Darussalam'
    WHEN Country = 'Northern Cyprus' THEN 'Cyprus'
    WHEN Country = 'Slovakia' THEN 'Slovak Republic'
    WHEN Country = 'Palestinian Territory, Occupied' THEN 'West Bank and Gaza'
    WHEN Country = 'Kyrgyzstan' THEN 'Kyrgyz Republic'
    WHEN Country = 'Syrian Arab Republic' THEN 'Syria'
    ELSE Country
    END;
    
/**Add ISO column into uni_rank_2025**/
ALTER TABLE uni_rank_2025
ADD COLUMN ISO VARCHAR(3);

/**Populate ISO column based on iso_region_mapping**/
UPDATE uni_rank_2025 a
	LEFT JOIN iso_region_mapping b 
		ON a.Country = b.Country
	SET a.ISO = b.ISO;
    
SET SQL_SAFE_UPDATES = 1;
    
/** Reorder ISO column **/ 
ALTER TABLE uni_rank_2025
MODIFY COLUMN ISO VARCHAR(3) AFTER Country;

/** Reorder Region column **/ 
ALTER TABLE uni_rank_2025
MODIFY COLUMN Region VARCHAR(50) AFTER ISO;

ALTER TABLE uni_rank_2025
DROP COLUMN Country;