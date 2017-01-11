/* -- Drop entire database and recreate 
CREATE DATABASE lucee_fw1_di1;
*/

/*****************************/
-- ORDER OF TABLE CREATION
/*****************************/
/*

User account related tables:
country
city
person
user
role
userRoleGroup
userPasswordReset
logUserPasswordReset
logUserSignIn

*/

/******************************************************************************/
-- DROP EVERYTHING
/******************************************************************************/

DROP TABLE IF EXISTS logUserSignIn;
DROP TABLE IF EXISTS logUserPasswordReset;
DROP TABLE IF EXISTS userPasswordReset;
DROP TABLE IF EXISTS userSignIn;
DROP TABLE IF EXISTS userRoleGroup;
DROP TABLE IF EXISTS "role";
DROP TABLE IF EXISTS "user";
DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS city;
DROP TABLE IF EXISTS country;

/******************************************************************************/
-- CREATE EVERYTHING
/******************************************************************************/

/******************************************************************************/

/******************************************************************************/
CREATE TABLE country(
	countryID serial NOT NULL PRIMARY KEY,
	countryCode3 char(3) NOT NULL,
	countryCode2 char(2) NOT NULL,
	UnIsoNumeric smallint NULL,
	countryName varchar(100) NULL,
	IanaInternet varchar(5) NULL,
	UnVehicle varchar(5) NULL,
	IocOlympic varchar(5) NULL,
	ItuCalling varchar(5) NULL,
	displayOrder smallint NULL DEFAULT 0,
	isDisplayed bit NULL DEFAULT 1::bit,
	createdAt timestamp with time zone NOT NULL,
	updatedAt timestamp with time zone NULL,
	removedAt timestamp with time zone NULL
);

/******************************************************************************/
CREATE TABLE city(
	cityID serial NOT NULL PRIMARY KEY,
	cityName varchar(100) NOT NULL,
	countryID integer NOT NULL REFERENCES country (countryID)
);

/******************************************************************************/
CREATE TABLE "user"(
	userID serial NOT NULL PRIMARY KEY,
	username varchar(120) NULL UNIQUE,
	password varchar(100) NOT NULL,
	salt varchar(40) NOT NULL,
	firstname varchar(30) NOT NULL,
	lastname varchar(30) NOT NULL,
	profileImage varchar(255) NULL,
	countryID int NULL REFERENCES country (countryID),
	dateOfBirth char(8) NULL,
	activationKey varchar(50) NOT NULL,
	activationCode varchar(15) NOT NULL,
	activationCodeCreatedAt timestamp with time zone NOT NULL,
	activatedAt timestamp with time zone NULL,
	createdAt timestamp with time zone NULL,
	updatedAt timestamp with time zone NULL,
	removedAt timestamp with time zone NULL
);

/******************************************************************************/
CREATE TABLE role(
	roleID serial NOT NULL PRIMARY KEY,
	roleName varchar(50) NOT NULL
);

/******************************************************************************/
CREATE TABLE userRoleGroup(
	userID int NOT NULL REFERENCES "user" (userID),
	roleID int NOT NULL REFERENCES role (roleID),
	CONSTRAINT userRoleGroup_pkey PRIMARY KEY (userID, roleID)
);

/******************************************************************************/
CREATE TABLE userPasswordReset(
	userID int NOT NULL REFERENCES "user" (userID),
	passwordResetCode varchar(15) NOT NULL,
	expiresAt timestamp with time zone NOT NULL,
	ipAddress varchar(39) NOT NULL,
	encryptedTimeStamp varchar(40) NULL,
	CONSTRAINT userPasswordReset_pkey PRIMARY KEY (userID, expiresAt)
);

/******************************************************************************/
CREATE TABLE logUserPasswordReset(
	userID int NOT NULL REFERENCES "user" (userID),
	resetRequestedAt timestamp with time zone NOT NULL,
	ipAddress varchar(39) NOT NULL,
	CONSTRAINT logUserPasswordReset_pkey PRIMARY KEY (userID, resetRequestedAt)
);

/******************************************************************************/
CREATE TABLE logUserSignIn(
	userID int NOT NULL REFERENCES "user" (userID),
	signedInAt timestamp with time zone NOT NULL,
	ipAddress varchar(39) NOT NULL,
	CONSTRAINT logUserSignIn_pkey PRIMARY KEY (userID, signedInAt)
);

/******************************************************************************/
-- POPULATE EVERYTHING
/******************************************************************************/

INSERT INTO role (roleName)
VALUES
('admin'),
('user');

--INSERT INTO "user" (username,password,salt,firstname,lastname,activationKey,activationCode,activationCodeCreatedAt,activatedAt,createdAt,updatedAt)
--VALUES ('test@example.com','PruHDf1UHcdSQBQVPywXncML6PAS/Jp82YbGXqB8I9g=','A50DAB1E7F01112F35CA4B0DED8B6B2A2D87E72D','Test','Person','',now() at time zone 'utc',now() at time zone 'utc',now() at time zone 'utc',now() at time zone 'utc');

/*INSERT INTO userRoleGroup (userID,roleID)
VALUES
(1,1),
(1,2);*/

INSERT INTO country (countryCode3, countryCode2, countryName, IanaInternet, ItuCalling, createdAt)
VALUES
('AFG', 'AF', 'Afghanistan', '.af', '93', now() at time zone 'utc'),
('ALB', 'AL', 'Albania', '.al', '355', now() at time zone 'utc'),
('DZA', 'DZ', 'Algeria (El Djazaïr)', '.dz', '213', now() at time zone 'utc'),
('ASM', 'AS', 'American Samoa', '.as', '1-684', now() at time zone 'utc'),
('AND', 'AD', 'Andorra', '.ad', '376', now() at time zone 'utc'),
('AGO', 'AO', 'Angola', '.ao', '244', now() at time zone 'utc'),
('AIA', 'AI', 'Anguilla', '.ai', '1-264', now() at time zone 'utc'),
('ATA', 'AQ', 'Antarctica', '.aq', '', now() at time zone 'utc'),
('ATG', 'AG', 'Antigua and Barbuda', '.ag', '1-268', now() at time zone 'utc'),
('ARG', 'AR', 'Argentina', '.ar', '54', now() at time zone 'utc'),
('ARM', 'AM', 'Armenia', '.am', '7', now() at time zone 'utc'),
('ABW', 'AW', 'Aruba', '.aw', '297', now() at time zone 'utc'),
('AUS', 'AU', 'Australia', '.au', '61', now() at time zone 'utc'),
('AUT', 'AT', 'Austria', '.at', '43', now() at time zone 'utc'),
('AZE', 'AZ', 'Azerbaijan', '.az', '994', now() at time zone 'utc'),
('BHS', 'BS', 'Bahamas', '.bs', '1-242', now() at time zone 'utc'),
('BHR', 'BH', 'Bahrain', '.bh', '973', now() at time zone 'utc'),
('BGD', 'BD', 'Bangladesh', '.bd', '880', now() at time zone 'utc'),
('BRB', 'BB', 'Barbados', '.bb', '1-246', now() at time zone 'utc'),
('BLR', 'BY', 'Belarus', '.by', '375', now() at time zone 'utc'),
('BEL', 'BE', 'Belgium', '.be', '32', now() at time zone 'utc'),
('BLZ', 'BZ', 'Belize', '.bz', '501', now() at time zone 'utc'),
('BEN', 'BJ', 'Benin', '.bj', '229', now() at time zone 'utc'),
('BMU', 'BM', 'Bermuda', '.bm', '1-441', now() at time zone 'utc'),
('BTN', 'BT', 'Bhutan', '.bt', '975', now() at time zone 'utc'),
('BOL', 'BO', 'Bolivia', '.bo', '591', now() at time zone 'utc'),
('BIH', 'BA', 'Bosnia and Herzegovina', '.ba', '387', now() at time zone 'utc'),
('BWA', 'BW', 'Botswana', '.bw', '267', now() at time zone 'utc'),
('BVT', 'BV', 'Bouvet Island', '.bv', '', now() at time zone 'utc'),
('BRA', 'BR', 'Brazil', '.br', '55', now() at time zone 'utc'),
('IOT', 'IO', 'British Indian Ocean Territory', '.io', '', now() at time zone 'utc'),
('BRN', 'BN', 'Brunei Darussalam', '.bn', '673', now() at time zone 'utc'),
('BGR', 'BG', 'Bulgaria', '.bg', '359', now() at time zone 'utc'),
('BFA', 'BF', 'Burkina Faso', '.bf', '226', now() at time zone 'utc'),
('BDI', 'BI', 'Burundi', '.bi', '257', now() at time zone 'utc'),
('KHM', 'KH', 'Cambodia', '.kh', '855', now() at time zone 'utc'),
('CMR', 'CM', 'Cameroon', '.cm', '237', now() at time zone 'utc'),
('CAN', 'CA', 'Canada', '.ca', '1', now() at time zone 'utc'),
('CPV', 'CV', 'Cape Verde', '.cv', '238', now() at time zone 'utc'),
('CYM', 'KY', 'Cayman Islands', '.ky', '1-345', now() at time zone 'utc'),
('CAF', 'CF', 'Central African Republic', '.cf', '236', now() at time zone 'utc'),
('TCD', 'TD', 'Chad Ttchad)', '.td', '235', now() at time zone 'utc'),
('CHL', 'CL', 'Chile', '.cl', '56', now() at time zone 'utc'),
('CHN', 'CN', 'China', '.cn', '86', now() at time zone 'utc'),
('CXR', 'CX', 'Christmas Island', '.cx', '', now() at time zone 'utc'),
('CCK', 'CC', 'Cocos (Keeling) Islands', '.cc', '', now() at time zone 'utc'),
('COL', 'CO', 'Colombia', '.co', '57', now() at time zone 'utc'),
('COM', 'KM', 'Comoros', '.km', '269', now() at time zone 'utc'),
('COG', 'CG', 'Congo, Republic of', '.cg', '242', now() at time zone 'utc'),
('COD', 'CD', 'Congo, The Democratic Republic of the', '.cd', '243', now() at time zone 'utc'),
('COK', 'CK', 'Cook Islands', '.ck', '682', now() at time zone 'utc'),
('CRI', 'CR', 'Costa Rica', '.cr', '506', now() at time zone 'utc'),
('CIV', 'CI', 'Côte D''ivoire (Ivory Coast)', '.ci', '225', now() at time zone 'utc'),
('HRV', 'HR', 'Croatia', '.hr', '385', now() at time zone 'utc'),
('CUB', 'CU', 'Cuba', '.cu', '53', now() at time zone 'utc'),
('CYP', 'CY', 'Cyprus', '.cy', '357', now() at time zone 'utc'),
('CZE', 'CZ', 'Czech Republic', '.cz', '420', now() at time zone 'utc'),
('DNK', 'DK', 'Denmark', '.dk', '45', now() at time zone 'utc'),
('DJI', 'DJ', 'Djibouti', '.dj', '253', now() at time zone 'utc'),
('DMA', 'DM', 'Dominica', '.dm', '1-767', now() at time zone 'utc'),
('DOM', 'DO', 'Dominican Republic', '.do', '1-809', now() at time zone 'utc'),
('ECU', 'EC', 'Ecuador', '.ec', '593', now() at time zone 'utc'),
('EGY', 'EG', 'Egypt', '.eg', '20', now() at time zone 'utc'),
('SLV', 'SV', 'El Salvador', '.sv', '503', now() at time zone 'utc'),
('GNQ', 'GQ', 'Equatorial Guinea', '.gq', '240', now() at time zone 'utc'),
('ERI', 'ER', 'Eritrea', '.er', '291', now() at time zone 'utc'),
('EST', 'EE', 'Estonia', '.ee', '372', now() at time zone 'utc'),
('ETH', 'ET', 'Ethiopia', '.et', '251', now() at time zone 'utc'),
('FRO', 'FO', 'Faeroe Islands', '.fo', '298', now() at time zone 'utc'),
('FLK', 'FK', 'Falkland Islands (Malvinas)', '.fk', '500', now() at time zone 'utc'),
('FJI', 'FJ', 'Fiji', '.fj', '679', now() at time zone 'utc'),
('FIN', 'FI', 'Finland', '.fi', '358', now() at time zone 'utc'),
('FRA', 'FR', 'France', '.fr', '33', now() at time zone 'utc'),
('GUF', 'GF', 'French Guiana', '.gf', '594', now() at time zone 'utc'),
('PYF', 'PF', 'French Polynesia', '.pf', '689', now() at time zone 'utc'),
('ATF', 'TF', 'French Southern Territories', '.tf', '', now() at time zone 'utc'),
('GAB', 'GA', 'Gabon', '.ga', '241', now() at time zone 'utc'),
('GMB', 'GM', 'Gambia, The', '.gm', '220', now() at time zone 'utc'),
('GEO', 'GE', 'Georgia', '.ge', '', now() at time zone 'utc'),
('DEU', 'DE', 'Germany', '.de', '49', now() at time zone 'utc'),
('GHA', 'GH', 'Ghana', '.gh', '233', now() at time zone 'utc'),
('GIB', 'GI', 'Gibraltar', '.gi', '350', now() at time zone 'utc'),
('GRC', 'GR', 'Greece', '.gr', '30', now() at time zone 'utc'),
('GRL', 'GL', 'Greenland', '.gl', '299', now() at time zone 'utc'),
('GRD', 'GD', 'Grenada', '.gd', '1-473', now() at time zone 'utc'),
('GLP', 'GP', 'Guadeloupe', '.gp', '590', now() at time zone 'utc'),
('GUM', 'GU', 'Guam', '.gu', '1-671', now() at time zone 'utc'),
('GTM', 'GT', 'Guatemala', '.gt', '502', now() at time zone 'utc'),
('GIN', 'GN', 'Guinea', '.gn', '224', now() at time zone 'utc'),
('GNB', 'GW', 'Guinea-bissau', '.gw', '245', now() at time zone 'utc'),
('GUY', 'GY', 'Guyana', '.gy', '592', now() at time zone 'utc'),
('HTI', 'HT', 'Haiti', '.ht', '509', now() at time zone 'utc'),
('HMD', 'HM', 'Heard Island and Mcdonald Islands', '.hm', '', now() at time zone 'utc'),
('HND', 'HN', 'Honduras', '.hn', '504', now() at time zone 'utc'),
('HKG', 'HK', 'Hong Kong', '.hk', '852', now() at time zone 'utc'),
('HUN', 'HU', 'Hungary', '.hu', '36', now() at time zone 'utc'),
('ISL', 'IS', 'Iceland', '.is', '354', now() at time zone 'utc'),
('IND', 'IN', 'India', '.in', '91', now() at time zone 'utc'),
('IDN', 'ID', 'Indonesia', '.id', '62', now() at time zone 'utc'),
('IRN', 'IR', 'Iran', '.ir', '98', now() at time zone 'utc'),
('IRQ', 'IQ', 'Iraq', '.iq', '964', now() at time zone 'utc'),
('IRL', 'IE', 'Ireland', '.ie', '353', now() at time zone 'utc'),
('ISR', 'IL', 'Israel', '.il', '972', now() at time zone 'utc'),
('ITA', 'IT', 'Italy', '.it', '39', now() at time zone 'utc'),
('JAM', 'JM', 'Jamaica', '.jm', '1-876', now() at time zone 'utc'),
('JPN', 'JP', 'Japan', '.jp', '81', now() at time zone 'utc'),
('JOR', 'JO', 'Jordan', '.jo', '962', now() at time zone 'utc'),
('KAZ', 'KZ', 'Kazakhstan', '.kz', '7', now() at time zone 'utc'),
('KEN', 'KE', 'Kenya', '.ke', '254', now() at time zone 'utc'),
('KIR', 'KI', 'Kiribati', '.ki', '686', now() at time zone 'utc'),
('PRK', 'KP', 'Korea (North)', '.kp', '850', now() at time zone 'utc'),
('KOR', 'KR', 'Korea (South)', '.kr', '82', now() at time zone 'utc'),
('KWT', 'KW', 'Kuwait', '.kw', '965', now() at time zone 'utc'),
('KGZ', 'KG', 'Kyrgyzstan', '.kg', '996', now() at time zone 'utc'),
('LAO', 'LA', 'Lao People''s Democratic Republic', '.la', '856', now() at time zone 'utc'),
('LVA', 'LV', 'Latvia', '.lv', '371', now() at time zone 'utc'),
('LBN', 'LB', 'Lebanon', '.lb', '961', now() at time zone 'utc'),
('LSO', 'LS', 'Lesotho', '.ls', '266', now() at time zone 'utc'),
('LBR', 'LR', 'Liberia', '.lr', '231', now() at time zone 'utc'),
('LBY', 'LY', 'Libya (Libyan Arab Jamahirya)', '.ly', '218', now() at time zone 'utc'),
('LIE', 'LI', 'Liechtenstein', '.li', '423', now() at time zone 'utc'),
('LTU', 'LT', 'Lithuania', '.lt', '370', now() at time zone 'utc'),
('ALA', 'AX', 'Lland Islands', '', '', now() at time zone 'utc'),
('LUX', 'LU', 'Luxembourg', '.lu', '352', now() at time zone 'utc'),
('MAC', 'MO', 'Macao', '.mo', '853', now() at time zone 'utc'),
('MKD', 'MK', 'Macedonia', '.mk', '389', now() at time zone 'utc'),
('MDG', 'MG', 'Madagascar', '.mg', '261', now() at time zone 'utc'),
('MWI', 'MW', 'Malawi', '.mw', '265', now() at time zone 'utc'),
('MYS', 'MY', 'Malaysia', '.my', '60', now() at time zone 'utc'),
('MDV', 'MV', 'Maldives', '.mv', '960', now() at time zone 'utc'),
('MLI', 'ML', 'Mali', '.ml', '223', now() at time zone 'utc'),
('MLT', 'MT', 'Malta', '.mt', '356', now() at time zone 'utc'),
('MHL', 'MH', 'Marshall Islands', '.mh', '692', now() at time zone 'utc'),
('MTQ', 'MQ', 'Martinique', '.mq', '596', now() at time zone 'utc'),
('MRT', 'MR', 'Mauritania', '.mr', '222', now() at time zone 'utc'),
('MUS', 'MU', 'Mauritius', '.mu', '230', now() at time zone 'utc'),
('MYT', 'YT', 'Mayotte', '.yt', '269', now() at time zone 'utc'),
('MEX', 'MX', 'Mexico', '.mx', '52', now() at time zone 'utc'),
('FSM', 'FM', 'Micronesia (Federated States of Micronesia)', '.fm', '691', now() at time zone 'utc'),
('MDA', 'MD', 'Moldova', '.md', '373', now() at time zone 'utc'),
('MCO', 'MC', 'Monaco', '.mc', '377', now() at time zone 'utc'),
('MNG', 'MN', 'Mongolia', '.mn', '976', now() at time zone 'utc'),
('MSR', 'MS', 'Montserrat', '.ms', '1-664', now() at time zone 'utc'),
('MAR', 'MA', 'Morocco', '.ma', '212', now() at time zone 'utc'),
('MOZ', 'MZ', 'Mozambique (Moçambique)', '.mz', '258', now() at time zone 'utc'),
('MMR', 'MM', 'Myanmar', '.mm', '95', now() at time zone 'utc'),
('XXX', 'XX', 'N/a', '', '', now() at time zone 'utc'),
('NAM', 'NA', 'Namibia', '.na', '264', now() at time zone 'utc'),
('NRU', 'NR', 'Nauru', '.nr', '674', now() at time zone 'utc'),
('NPL', 'NP', 'Nepal', '.np', '977', now() at time zone 'utc'),
('NLD', 'NL', 'Netherlands', '.nl', '31', now() at time zone 'utc'),
('ANT', 'AN', 'Netherlands Antilles', '.an', '599', now() at time zone 'utc'),
('NCL', 'NC', 'New Caledonia', '.nc', '687', now() at time zone 'utc'),
('NZL', 'NZ', 'New Zealand', '.nz', '64', now() at time zone 'utc'),
('NIC', 'NI', 'Nicaragua', '.ni', '505', now() at time zone 'utc'),
('NER', 'NE', 'Niger', '.ne', '227', now() at time zone 'utc'),
('NGA', 'NG', 'Nigeria', '.ng', '234', now() at time zone 'utc'),
('NIU', 'NU', 'Niue', '.nu', '683', now() at time zone 'utc'),
('NFK', 'NF', 'Norfolk Island', '.nf', '', now() at time zone 'utc'),
('MNP', 'MP', 'Northern Mariana Islands', '.mp', '1-670', now() at time zone 'utc'),
('NOR', 'NO', 'Norway', '.no', '47', now() at time zone 'utc'),
('OMN', 'OM', 'Oman', '.om', '968', now() at time zone 'utc'),
('PAK', 'PK', 'Pakistan', '.pk', '92', now() at time zone 'utc'),
('PLW', 'PW', 'Palau', '.pw', '680', now() at time zone 'utc'),
('PSE', 'PS', 'Palestinian Territories', '.ps', '970', now() at time zone 'utc'),
('PAN', 'PA', 'Panama', '.pa', '507', now() at time zone 'utc'),
('PNG', 'PG', 'Papua New Guinea', '.pg', '675', now() at time zone 'utc'),
('PRY', 'PY', 'Paraguay', '.py', '595', now() at time zone 'utc'),
('PER', 'PE', 'Peru', '.pe', '51', now() at time zone 'utc'),
('PHL', 'PH', 'Philippines', '.ph', '63', now() at time zone 'utc'),
('PCN', 'PN', 'Pitcairn', '.pn', '', now() at time zone 'utc'),
('POL', 'PL', 'Poland', '.pl', '48', now() at time zone 'utc'),
('PRT', 'PT', 'Portugal', '.pt', '351', now() at time zone 'utc'),
('PRI', 'PR', 'Puerto Rico', '.pr', '1', now() at time zone 'utc'),
('QAT', 'QA', 'Qatar', '.qa', '974', now() at time zone 'utc'),
('REU', 'RE', 'Réunion', '.re', '262', now() at time zone 'utc'),
('ROU', 'RO', 'Romania', '.ro', '40', now() at time zone 'utc'),
('RUS', 'RU', 'Russian Federation', '.ru', '7', now() at time zone 'utc'),
('RWA', 'RW', 'Rwanda', '.rw', '250', now() at time zone 'utc'),
('SHN', 'SH', 'Saint Helena', '.sh', '290', now() at time zone 'utc'),
('KNA', 'KN', 'Saint Kitts and Nevis', '.kn', '1-869', now() at time zone 'utc'),
('LCA', 'LC', 'Saint Lucia', '.lc', '1-758', now() at time zone 'utc'),
('SPM', 'PM', 'Saint Pierre and Miquelon', '.pm', '508', now() at time zone 'utc'),
('VCT', 'VC', 'Saint Vincent and the Grenadines', '.vc', '1-784', now() at time zone 'utc'),
('WSM', 'WS', 'Samoa Fformerly Western Samoa)', '.ws', '685', now() at time zone 'utc'),
('SMR', 'SM', 'San Marino (Republic of)', '.sm', '378', now() at time zone 'utc'),
('STP', 'ST', 'Sao Tome and Principe', '.st', '239', now() at time zone 'utc'),
('SAU', 'SA', 'Saudi Arabia', '.sa', '966', now() at time zone 'utc'),
('SEN', 'SN', 'Senegal', '.sn', '221', now() at time zone 'utc'),
('SCG', 'CS', 'Serbia and Montenegro', '.yu', '381', now() at time zone 'utc'),
('SYC', 'SC', 'Seychelles', '.sc', '248', now() at time zone 'utc'),
('SLE', 'SL', 'Sierra Leone', '.sl', '232', now() at time zone 'utc'),
('SGP', 'SG', 'Singapore', '.sg', '65', now() at time zone 'utc'),
('SVK', 'SK', 'Slovakia Sslovak Republic)', '.sk', '421', now() at time zone 'utc'),
('SVN', 'SI', 'Slovenia', '.si', '386', now() at time zone 'utc'),
('SLB', 'SB', 'Solomon Islands', '.sb', '677', now() at time zone 'utc'),
('SOM', 'SO', 'Somalia', '.so', '252', now() at time zone 'utc'),
('ZAF', 'ZA', 'South Africa', '.za', '27', now() at time zone 'utc'),
('SGS', 'GS', 'South Georgia and the South Sandwich Islands', '.gs', '', now() at time zone 'utc'),
('ESP', 'ES', 'Spain', '.es', '34', now() at time zone 'utc'),
('LKA', 'LK', 'Sri Lanka', '.lk', '94', now() at time zone 'utc'),
('SDN', 'SD', 'Sudan', '.sd', '249', now() at time zone 'utc'),
('SUR', 'SR', 'Suriname', '.sr', '597', now() at time zone 'utc'),
('SJM', 'SJ', 'Svalbard and Jan Mayen', '.sj', '', now() at time zone 'utc'),
('SWZ', 'SZ', 'Swaziland', '.sz', '268', now() at time zone 'utc'),
('SWE', 'SE', 'Sweden', '.se', '46', now() at time zone 'utc'),
('CHE', 'CH', 'Switzerland', '.ch', '41', now() at time zone 'utc'),
('SYR', 'SY', 'Syrian Arab Republic', '.sy', '963', now() at time zone 'utc'),
('TWN', 'TW', 'Taiwan', '.tw', '886', now() at time zone 'utc'),
('TJK', 'TJ', 'Tajikistan', '.tj', '992', now() at time zone 'utc'),
('TZA', 'TZ', 'Tanzania', '.tz', '255', now() at time zone 'utc'),
('THA', 'TH', 'Thailand', '.th', '66', now() at time zone 'utc'),
('TLS', 'TL', 'Timor-leste', '.tp', '670', now() at time zone 'utc'),
('TGO', 'TG', 'Togo', '.tg', '228', now() at time zone 'utc'),
('TKL', 'TK', 'Tokelau', '.tk', '690', now() at time zone 'utc'),
('TON', 'TO', 'Tonga', '.to', '676', now() at time zone 'utc'),
('TTO', 'TT', 'Trinidad and Tobago', '.tt', '1-868', now() at time zone 'utc'),
('TUN', 'TN', 'Tunisia', '.tn', '216', now() at time zone 'utc'),
('TUR', 'TR', 'Turkey', '.tr', '90', now() at time zone 'utc'),
('TKM', 'TM', 'Turkmenistan', '.tm', '993', now() at time zone 'utc'),
('TCA', 'TC', 'Turks and Caicos Islands', '.tc', '1-649', now() at time zone 'utc'),
('TUV', 'TV', 'Tuvalu', '.tv', '688', now() at time zone 'utc'),
('UGA', 'UG', 'Uganda', '.ug', '256', now() at time zone 'utc'),
('UKR', 'UA', 'Ukraine', '.ua', '380', now() at time zone 'utc'),
('ARE', 'AE', 'United Arab Emirates', '.ae', '971', now() at time zone 'utc'),
('GBR', 'GB', 'United Kingdom', '.uk', '44', now() at time zone 'utc'),
('USA', 'US', 'United States', '.us', '1', now() at time zone 'utc'),
('UMI', 'UM', 'United States Minor Outlying Islands', '.um', '', now() at time zone 'utc'),
('URY', 'UY', 'Uruguay', '.uy', '598', now() at time zone 'utc'),
('UZB', 'UZ', 'Uzbekistan', '.uz', '998', now() at time zone 'utc'),
('VUT', 'VU', 'Vanuatu', '.vu', '678', now() at time zone 'utc'),
('VAT', 'VA', 'Vatican City Hholy See)', '.va', '379', now() at time zone 'utc'),
('VEN', 'VE', 'Venezuela', '.ve', '58', now() at time zone 'utc'),
('VNM', 'VN', 'Vietnam', '.vn', '84', now() at time zone 'utc'),
('VGB', 'VG', 'Virgin Islands, British', '.vg', '1-284', now() at time zone 'utc'),
('VIR', 'VI', 'Virgin Islands, U.s.', '.vi', '1-340', now() at time zone 'utc'),
('WLF', 'WF', 'Wallis and Futuna', '.wf', '681', now() at time zone 'utc'),
('ESH', 'EH', 'Western Sahara', '.eh', '', now() at time zone 'utc'),
('YEM', 'YE', 'Yemen', '.ye', '967', now() at time zone 'utc'),
('ZMB', 'ZM', 'Zambia', '.zm', '260', now() at time zone 'utc'),
('ZWE', 'ZW', 'Zimbabwe', '.zw', '263', now() at time zone 'utc');