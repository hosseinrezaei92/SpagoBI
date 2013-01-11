--inserts configuration for check of role in login module
INSERT INTO SBI_CONFIG ( ID, LABEL, NAME, DESCRIPTION, IS_ACTIVE, VALUE_CHECK, VALUE_TYPE_ID, CATEGORY, USER_IN, TIME_IN) VALUES ((SELECT next_val FROM hibernate_sequences WHERE sequence_name = 'SBI_CONFIG'),'SPAGOBI.SECURITY.CHECK_ROLE_LOGIN', 'SPAGOBI.SECURITY.CHECK_ROLE_LOGIN', 'Check the correct role in login action', false, 'false',(select VALUE_ID from SBI_DOMAINS where VALUE_CD = 'STRING' AND DOMAIN_CD = 'PAR_TYPE'), 'SECURITY', 'biadmin', current_timestamp);\p\g
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_CONFIG';\p\g
INSERT INTO SBI_CONFIG ( ID, LABEL, NAME, DESCRIPTION, IS_ACTIVE, VALUE_CHECK, VALUE_TYPE_ID, CATEGORY, USER_IN, TIME_IN) VALUES ((SELECT next_val FROM hibernate_sequences WHERE sequence_name = 'SBI_CONFIG'),'SPAGOBI.SECURITY.ROLE_LOGIN', 'SPAGOBI.SECURITY.ROLE_LOGIN', 'The value of the role to check at login module', false, '',(select VALUE_ID from SBI_DOMAINS where VALUE_CD = 'STRING' AND DOMAIN_CD = 'PAR_TYPE'), 'SECURITY', 'biadmin', current_timestamp);\p\g
update hibernate_sequences set next_val = next_val+1 where sequence_name = 'SBI_CONFIG';\p\g

COMMIT;\p\g

-- 11/01/2014 Andrea: added some new selection modalities for analytical driver to domain table
DELETE FROM sbi_domains WHERE domain_cd = 'SELECTION_TYPE';
INSERT INTO sbi_domains (VALUE_CD, VALUE_NM, DOMAIN_CD, DOMAIN_NM, VALUE_DS, USER_IN, ORGANIZATION)
VALUES ('LIST', 'sbidomains.nm.list', 'SELECTION_TYPE', 'Selection modality of parameter values', 'sbidomains.ds.list', 'SPAGOBI', 'SPAGOBI');
INSERT INTO sbi_domains (VALUE_CD, VALUE_NM, DOMAIN_CD, DOMAIN_NM, VALUE_DS, USER_IN, ORGANIZATION)
VALUES ('LOOKUP', 'sbidomains.nm.lookup', 'SELECTION_TYPE', 'Selection modality of parameter values', 'sbidomains.ds.lookup', 'SPAGOBI', 'SPAGOBI');
INSERT INTO sbi_domains (VALUE_CD, VALUE_NM, DOMAIN_CD, DOMAIN_NM, VALUE_DS, USER_IN, ORGANIZATION)
VALUES ('SLIDER', 'sbidomains.nm.slider', 'SELECTION_TYPE', 'Selection modality of parameter values', 'sbidomains.ds.slider', 'SPAGOBI', 'SPAGOBI');
INSERT INTO sbi_domains (VALUE_CD, VALUE_NM, DOMAIN_CD, DOMAIN_NM, VALUE_DS, USER_IN, ORGANIZATION)
VALUES ('TREE', 'sbidomains.nm.tree', 'SELECTION_TYPE', 'Selection modality of parameter values', 'sbidomains.ds.tree', 'SPAGOBI', 'SPAGOBI');
COMMIT;\p\g
