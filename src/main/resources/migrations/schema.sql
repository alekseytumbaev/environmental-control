/*
Created: 26.10.2023
Modified: 26.10.2023
Model: PostgreSQL 12
Database: PostgreSQL 12
*/

-- Create tables section -------------------------------------------------

-- Table Company

CREATE TABLE "Company"
(
    "PK_Company"         Serial                NOT NULL,
    "name"               Character varying(50) NOT NULL UNIQUE,
    "date_foundation"    Date,
    "purpose_prodaction" Text,
    "norm_gas_emission"  Real                  NOT NULL,
    "norm_water_emisson" Real                  NOT NULL
)
    WITH (
        autovacuum_enabled = true)
;

ALTER TABLE "Company"
    ADD CONSTRAINT "PK_Company" PRIMARY KEY ("PK_Company")
;

-- Table Type_Company

CREATE TABLE "Type_Company"
(
    "PK_Type_Company" Serial                NOT NULL,
    "name"            Character varying(50) NOT NULL
)
    WITH (
        autovacuum_enabled = true)
;

ALTER TABLE "Type_Company"
    ADD CONSTRAINT "PK_Type_Company" PRIMARY KEY ("PK_Type_Company")
;

-- Table Founders

CREATE TABLE "Founders"
(
    "PK_Founders"     Serial                 NOT NULL,
    "FIO"             Character varying(100) NOT NULL,
    "number_phone"    Character varying(11),
    "seria_passport"  Character varying(4),
    "number_passport" Character varying(6),
    "PK_Company"      Integer
)
    WITH (
        autovacuum_enabled = true)
;

CREATE INDEX "IX_Relationship5" ON "Founders" ("PK_Company")
;

ALTER TABLE "Founders"
    ADD CONSTRAINT "PK_Founders" PRIMARY KEY ("PK_Founders")
;

-- Table Type_Company-Company

CREATE TABLE "Type_Company-Company"
(
    "PK_Type_Company" Integer NOT NULL,
    "PK_Company"      Integer NOT NULL
)
    WITH (
        autovacuum_enabled = true)
;

ALTER TABLE "Type_Company-Company"
    ADD CONSTRAINT "PK_Type_Company-Company" PRIMARY KEY ("PK_Type_Company", "PK_Company")
;

-- Table ResponsibleSotrud

CREATE TABLE "ResponsibleSotrud"
(
    "PK_ResponsibleSotrud" Serial                 NOT NULL,
    "FIO"                  Character varying(100) NOT NULL,
    "number"               Character varying(11),
    "seria_passport"       Character varying(4),
    "number_passport"      Character varying(6),
    "type_activity"        Text,
    "PK_Company"           Integer
)
    WITH (
        autovacuum_enabled = true)
;

CREATE INDEX "IX_Relationship19" ON "ResponsibleSotrud" ("PK_Company")
;

ALTER TABLE "ResponsibleSotrud"
    ADD CONSTRAINT "PK_ResponsibleSotrud" PRIMARY KEY ("PK_ResponsibleSotrud")
;

-- Table Device

CREATE TABLE "Device"
(
    "PK_Device"      Serial                NOT NULL,
    "long_life"      Date,
    "data_installed" Date                  NOT NULL,
    "date_lastServ"  Date                  NOT NULL,
    "PK_Company"     Integer,
    "PK_SensorGase"  Integer,
    "PK_SensorWater" Integer,
    "serial_number"  Character varying(50) NOT NULL
)
    WITH (
        autovacuum_enabled = true)
;

CREATE INDEX "IX_Relationship20" ON "Device" ("PK_Company")
;

CREATE INDEX "IX_Relationship26" ON "Device" ("PK_SensorGase")
;

CREATE INDEX "IX_Relationship31" ON "Device" ("PK_SensorWater")
;

ALTER TABLE "Device"
    ADD CONSTRAINT "PK_Device" PRIMARY KEY ("PK_Device")
;

-- Table LogWater

CREATE TABLE "LogWater"
(
    "PK_LogWater"     Serial  NOT NULL,
    "Indecator"       Real    NOT NULL,
    "date_lastUpdate" Date    NOT NULL,
    "PK_Device"       Integer NOT NULL
)
    WITH (
        autovacuum_enabled = true)
;

CREATE INDEX "IX_Relationship21" ON "LogWater" ("PK_Device")
;

ALTER TABLE "LogWater"
    ADD CONSTRAINT "PK_LogWater" PRIMARY KEY ("PK_LogWater")
;

-- Table LogGas

CREATE TABLE "LogGas"
(
    "PK_LogGas"         Serial  NOT NULL,
    "Indicator"         Real    NOT NULL,
    "date_lastUpdate"   Date    NOT NULL,
    "PK_Device"         Integer NOT NULL,
    "PK_PollutionGases" Integer NOT NULL
)
    WITH (
        autovacuum_enabled = true)
;

CREATE INDEX "IX_Relationship22" ON "LogGas" ("PK_Device")
;

CREATE INDEX "IX_Relationship32" ON "LogGas" ("PK_PollutionGases")
;

ALTER TABLE "LogGas"
    ADD CONSTRAINT "PK_LogGas" PRIMARY KEY ("PK_LogGas")
;

-- Table PollutionGases

CREATE TABLE "PollutionGases"
(
    "PK_PollutionGases" Serial                NOT NULL,
    "name"              Character varying(50) NOT NULL,
    "consentrate"       Integer               NOT NULL
)
    WITH (
        autovacuum_enabled = true)
;

ALTER TABLE "PollutionGases"
    ADD CONSTRAINT "PK_PollutionGases" PRIMARY KEY ("PK_PollutionGases")
;

-- Table SensorGas

CREATE TABLE "SensorGas"
(
    "PK_SensorGase" Serial                NOT NULL,
    "name"          Character varying(50) NOT NULL,
    "sensetivity"   Integer,
    "marks"         Character varying(50),
    "PK_Brand"      Integer
)
    WITH (
        autovacuum_enabled = true)
;

CREATE INDEX "IX_Relationship29" ON "SensorGas" ("PK_Brand")
;

ALTER TABLE "SensorGas"
    ADD CONSTRAINT "PK_SensorGas" PRIMARY KEY ("PK_SensorGase")
;

-- Table SensorWater

CREATE TABLE "SensorWater"
(
    "PK_SensorWater" Serial                NOT NULL,
    "name"           Character varying(50) NOT NULL,
    "sensitivity"    Integer,
    "mark"           Character varying(50),
    "PK_Brand"       Integer
)
    WITH (
        autovacuum_enabled = true)
;

CREATE INDEX "IX_Relationship28" ON "SensorWater" ("PK_Brand")
;

ALTER TABLE "SensorWater"
    ADD CONSTRAINT "PK_SensorWater" PRIMARY KEY ("PK_SensorWater")
;

-- Table Brand

CREATE TABLE "Brand"
(
    "PK_Brand" Serial                NOT NULL,
    "name"     Character varying(50) NOT NULL
)
    WITH (
        autovacuum_enabled = true)
;

ALTER TABLE "Brand"
    ADD CONSTRAINT "PK_Brand" PRIMARY KEY ("PK_Brand")
;

-- Create foreign keys (relationships) section -------------------------------------------------

ALTER TABLE "Founders"
    ADD CONSTRAINT "Relationship5"
        FOREIGN KEY ("PK_Company")
            REFERENCES "Company" ("PK_Company")
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
;

ALTER TABLE "Type_Company-Company"
    ADD CONSTRAINT "Relationship15"
        FOREIGN KEY ("PK_Type_Company")
            REFERENCES "Type_Company" ("PK_Type_Company")
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
;

ALTER TABLE "Type_Company-Company"
    ADD CONSTRAINT "Relationship16"
        FOREIGN KEY ("PK_Company")
            REFERENCES "Company" ("PK_Company")
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
;

ALTER TABLE "ResponsibleSotrud"
    ADD CONSTRAINT "Relationship19"
        FOREIGN KEY ("PK_Company")
            REFERENCES "Company" ("PK_Company")
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
;

ALTER TABLE "Device"
    ADD CONSTRAINT "Relationship20"
        FOREIGN KEY ("PK_Company")
            REFERENCES "Company" ("PK_Company")
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
;

ALTER TABLE "LogWater"
    ADD CONSTRAINT "Relationship21"
        FOREIGN KEY ("PK_Device")
            REFERENCES "Device" ("PK_Device")
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
;

ALTER TABLE "LogGas"
    ADD CONSTRAINT "Relationship22"
        FOREIGN KEY ("PK_Device")
            REFERENCES "Device" ("PK_Device")
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
;

ALTER TABLE "Device"
    ADD CONSTRAINT "Relationship26"
        FOREIGN KEY ("PK_SensorGase")
            REFERENCES "SensorGas" ("PK_SensorGase")
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
;

ALTER TABLE "SensorWater"
    ADD CONSTRAINT "Relationship28"
        FOREIGN KEY ("PK_Brand")
            REFERENCES "Brand" ("PK_Brand")
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
;

ALTER TABLE "SensorGas"
    ADD CONSTRAINT "Relationship29"
        FOREIGN KEY ("PK_Brand")
            REFERENCES "Brand" ("PK_Brand")
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
;

ALTER TABLE "Device"
    ADD CONSTRAINT "Relationship31"
        FOREIGN KEY ("PK_SensorWater")
            REFERENCES "SensorWater" ("PK_SensorWater")
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
;

ALTER TABLE "LogGas"
    ADD CONSTRAINT "Relationship32"
        FOREIGN KEY ("PK_PollutionGases")
            REFERENCES "PollutionGases" ("PK_PollutionGases")
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
;

CREATE TABLE "Incidents"
(
    "PK_Incident" Serial NOT NULL,
    "incident_date" Date,
    "log_water" real,
    "log_gas"   real,
    "company_name"  varchar(50),
    "founder_fio"  varchar(100),
    "responsible_employee_fio" varchar(100),
    "device_serial_number" varchar(50),
    CONSTRAINT "PK_Incidents" PRIMARY KEY ("PK_Incident")
)
    WITH (
        autovacuum_enabled = true)
;





