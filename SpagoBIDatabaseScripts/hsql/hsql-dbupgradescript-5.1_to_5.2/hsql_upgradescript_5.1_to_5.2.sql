CREATE MEMORY TABLE SBI_CACHE_ITEM (SIGNATURE VARCHAR(100) NOT NULL, NAME VARCHAR(100) NULL, TABLE_NAME VARCHAR(100) NOT NULL, DIMENSION NUMERIC NULL, CREATION_DATE DATE NULL, LAST_USED_DATE DATE NULL, PROPERTIES VARCHAR NULL, USER_IN VARCHAR(100) NOT NULL, USER_UP VARCHAR(100), USER_DE VARCHAR(100), TIME_IN TIMESTAMP NOT NULL, TIME_UP TIMESTAMP , TIME_DE TIMESTAMP , SBI_VERSION_IN VARCHAR(10), SBI_VERSION_UP VARCHAR(10), SBI_VERSION_DE VARCHAR(10), META_VERSION VARCHAR(100), ORGANIZATION VARCHAR(20), CONSTRAINT XAK1SBI_CACHE_ITEM UNIQUE  (TABLE_NAME), PRIMARY KEY (SIGNATURE))
commit;
CREATE MEMORY TABLE SBI_CACHE_JOINED_ITEM (ID INTEGER  NOT NULL, SIGNATURE	VARCHAR(100) NOT NULL, JOINED_SIGNATURE	VARCHAR(100) NOT NULL, USER_IN VARCHAR(100) NOT NULL, USER_UP VARCHAR(100), USER_DE VARCHAR(100), TIME_IN TIMESTAMP NOT NULL, TIME_UP TIMESTAMP, TIME_DE TIMESTAMP, SBI_VERSION_IN VARCHAR(10), SBI_VERSION_UP VARCHAR(10), SBI_VERSION_DE VARCHAR(10), META_VERSION VARCHAR(100), ORGANIZATION VARCHAR(20), CONSTRAINT XAK1SBI_CACHE_JOINED_ITEM UNIQUE (SIGNATURE, JOINED_SIGNATURE), PRIMARY KEY (ID))
commit;
ALTER TABLE SBI_CACHE_JOINED_ITEM  ADD CONSTRAINT FK_SBI_CACHE_JOINED_ITEM_1 FOREIGN KEY ( SIGNATURE ) REFERENCES  SBI_CACHE_ITEM  ( SIGNATURE ) ON DELETE NO ACTION ON UPDATE CASCADE
commit;
ALTER TABLE SBI_CACHE_JOINED_ITEM  ADD CONSTRAINT FK_SBI_CACHE_JOINED_ITEM_2 FOREIGN KEY ( JOINED_SIGNATURE ) REFERENCES  SBI_CACHE_ITEM  ( SIGNATURE ) ON DELETE CASCADE ON UPDATE CASCADE
commit;

ALTER TABLE SBI_META_MODELS ADD COLUMN MODEL_LOCKED BOOLEAN BEFORE USER_IN, ADD COLUMN MODEL_LOCKER VARCHAR(100);
	
-- Date Range
ALTER TABLE SBI_PARUSE 
	ADD COLUMN OPTIONS VARCHAR(4000) NULL;

ALTER TABLE SBI_THRESHOLD_VALUE ALTER COLUMN POSITION RENAME TO KPI_POSITION;

-- Version number
INSERT INTO SBI_CONFIG ( ID, LABEL, NAME, DESCRIPTION, IS_ACTIVE, VALUE_CHECK, VALUE_TYPE_ID, CATEGORY, USER_IN, TIME_IN) VALUES 
((SELECT next_val FROM hibernate_sequences WHERE sequence_name = 'SBI_CONFIG'), 
'SPAGOBI.SPAGOBI_VERSION_NUMBER', 'SPAGOBI.SPAGOBI_VERSION_NUMBER', 
'SpagoBI version number', true, '5.2.0',
(select VALUE_ID from SBI_DOMAINS where VALUE_CD = 'STRING' AND DOMAIN_CD = 'PAR_TYPE'), 
'GENERIC_CONFIGURATION', 'biadmin', current_timestamp);
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_CONFIG';
commit;