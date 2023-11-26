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
    "name"               Character varying(50) NOT NULL,
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



-- Триггер, срабатывающий при добавлении данных в таблицу "LogGas".
-- Если по значению, которое пытаются записать, предприятие превысило норму газа - выводится сообщение об этом.
-- При этом значение записывается в любом случае
CREATE OR REPLACE FUNCTION write_warning_on_log_gas_over_limit()
    RETURNS TRIGGER AS
$$
BEGIN
    DECLARE
        company_norm_gas_emission REAL;
        company_id                INTEGER;
        curr_gas_emission         REAL;
        gas_concentrate           INTEGER;
    BEGIN
        -- получаем id и норму газа предприятия, показания для которого записываем
        SELECT c."PK_Company", c."norm_gas_emission"
        INTO company_id, company_norm_gas_emission
        FROM "Device" d
                 JOIN "Company" c ON d."PK_Company" = c."PK_Company"
        WHERE d."PK_Device" = NEW."PK_Device";

        -- получаем текущие показания
        SELECT SUM(lg."Indicator" * pg."consentrate")
        INTO curr_gas_emission
        FROM "LogGas" lg
                 JOIN "PollutionGases" pg ON lg."PK_PollutionGases" = pg."PK_PollutionGases"
                 JOIN (SELECT lg."PK_Device", MAX(lg."date_lastUpdate") AS latest_date
                       FROM "LogGas" lg
                                JOIN "Device" d ON lg."PK_Device" = d."PK_Device"
                       WHERE d."PK_Company" = company_id
                         AND d."PK_Device" != NEW."PK_Device"
                       GROUP BY lg."PK_Device") latest_logs
                      ON lg."PK_Device" = latest_logs."PK_Device" AND lg."date_lastUpdate" = latest_logs.latest_date;

        -- получаем концентрацию газа
        SELECT "consentrate"
        INTO gas_concentrate
        FROM "PollutionGases" pg
        WHERE pg."PK_PollutionGases" = NEW."PK_PollutionGases";

        IF curr_gas_emission + (NEW."Indicator" * gas_concentrate) > company_norm_gas_emission THEN
            RAISE NOTICE 'Предприятие превысило норму газа!';
        END IF;
    END;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER write_warning_on_log_gas_over_limit_trigger
    BEFORE INSERT
    ON "LogGas"
    FOR EACH ROW
EXECUTE PROCEDURE write_warning_on_log_gas_over_limit();


-- Триггер, срабатывающий при добавлении данных в таблицу "LogWater".
-- Если по значению, которое пытаются записать, предприятие превысило норму выбросов в воду - выводится сообщение об этом.
-- При этом значение записывается в любом случае
CREATE OR REPLACE FUNCTION write_warning_on_log_water_over_limit()
    RETURNS TRIGGER AS
$$
BEGIN
    DECLARE
        company_norm_water_emission REAL;
        company_id                  INTEGER;
        curr_water_emission         REAL;
    BEGIN
        -- получаем id и норму газа предприятия, показания для которого записываем
        SELECT c."PK_Company", c."norm_water_emisson"
        INTO company_id, company_norm_water_emission
        FROM "Device" d
                 JOIN "Company" c ON d."PK_Company" = c."PK_Company"
        WHERE d."PK_Device" = NEW."PK_Device";

        -- получаем текущие показания
        SELECT SUM(lw."Indecator")
        INTO curr_water_emission
        FROM "LogWater" lw
                 JOIN (SELECT lw."PK_Device", MAX(lw."date_lastUpdate") AS latest_date
                       FROM "LogWater" lw
                                JOIN "Device" d ON lw."PK_Device" = d."PK_Device"
                       WHERE d."PK_Company" = company_id
                         AND d."PK_Device" != NEW."PK_Device"
                       GROUP BY lw."PK_Device") latest_logs
                      ON lw."PK_Device" = latest_logs."PK_Device" AND lw."date_lastUpdate" = latest_logs.latest_date;

        IF curr_water_emission + NEW."Indecator" > company_norm_water_emission THEN
            RAISE NOTICE 'Предприятие превысило норму выбросов в воду!';
        END IF;
    END;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER write_warning_on_log_water_over_limit_trigger
    BEFORE INSERT
    ON "LogWater"
    FOR EACH ROW
EXECUTE PROCEDURE write_warning_on_log_water_over_limit();

-- Триггер: удаление сотрудника.
-- Проверяет, что нет нарушений на предприятии, за которое он ответственен, если есть - не дает удалить
CREATE OR REPLACE FUNCTION delete_employee_if_no_violations()
    RETURNS TRIGGER AS
$$
BEGIN
    DECLARE
        company_norm_gas_emission   REAL;
        company_norm_water_emission REAL;
        curr_gas_emission           REAL;
        curr_water_emission         REAL;
    BEGIN

        -- получаем норму выбросов предприятия, на котором сотрудник работает
        SELECT "norm_gas_emission", "norm_water_emisson"
        INTO company_norm_gas_emission, company_norm_water_emission
        FROM "Company"
        WHERE "PK_Company" = OLD."PK_Company";

        -- получаем текущие показания воды
        SELECT SUM(lw."Indecator")
        INTO curr_water_emission
        FROM "LogWater" lw
                 JOIN (SELECT lw."PK_Device", MAX(lw."date_lastUpdate") AS latest_date
                       FROM "LogWater" lw
                                JOIN "Device" d ON lw."PK_Device" = d."PK_Device"
                       WHERE d."PK_Company" = OLD."PK_Company"
                       GROUP BY lw."PK_Device") latest_logs
                      ON lw."PK_Device" = latest_logs."PK_Device" AND lw."date_lastUpdate" = latest_logs.latest_date;

        -- получаем текущие показания газа
        SELECT SUM(lg."Indicator" * pg."consentrate")
        INTO curr_gas_emission
        FROM "LogGas" lg
                 JOIN "PollutionGases" pg ON lg."PK_PollutionGases" = pg."PK_PollutionGases"
                 JOIN (SELECT lg."PK_Device", MAX(lg."date_lastUpdate") AS latest_date
                       FROM "LogGas" lg
                                JOIN "Device" d ON lg."PK_Device" = d."PK_Device"
                       WHERE d."PK_Company" = OLD."PK_Company"
                       GROUP BY lg."PK_Device") latest_logs
                      ON lg."PK_Device" = latest_logs."PK_Device" AND lg."date_lastUpdate" = latest_logs.latest_date;

        IF curr_gas_emission > company_norm_gas_emission OR curr_water_emission > company_norm_water_emission THEN
            RAISE EXCEPTION 'Невозможно удалить сотрудника, поскольку на предприятии имеются нарушения!';
        END IF;
    END;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delete_employee_if_no_violations_trigger
    BEFORE DELETE
    ON "ResponsibleSotrud"
    FOR EACH ROW
EXECUTE PROCEDURE delete_employee_if_no_violations();


-- процедура: добавление нового предприятия вместе с типом, учредителем и ответственным
CREATE OR REPLACE PROCEDURE add_company(
    --компания
    company_name varchar(50),
    company_date_foundation date,
    purpose_production text,
    company_norm_gas_emission real,
    company_norm_water_emission real,
    --тип
    type_name varchar(50),
    --учредитель
    founder_fio varchar(100),
    founder_number_phone varchar(11),
    founder_seria_passport varchar(4),
    founder_number_passport varchar(6),
    -- ответственный
    employee_fio varchar(11),
    employee_number_phone varchar(11),
    employee_seria_passport varchar(4),
    employee_number_passport varchar(6),
    employee_type_activity text,
    OUT added_company_id integer)
AS
$$
DECLARE
    type_id INTEGER;
BEGIN
    -- добавляем тип
    INSERT INTO "Type_Company" ("name")
    VALUES (type_name)
    RETURNING "PK_Type_Company" INTO type_id;

    -- добавляем компанию
    INSERT INTO "Company" ("name", "date_foundation", "purpose_prodaction", "norm_gas_emission", "norm_water_emisson")
    VALUES (company_name, company_date_foundation, purpose_production, company_norm_gas_emission,
            company_norm_water_emission)
    RETURNING "PK_Company" INTO added_company_id;

    -- соединяем компанию с типом
    INSERT INTO "Type_Company-Company" ("PK_Type_Company", "PK_Company")
    VALUES (type_id, added_company_id);

    -- добавляем учредителя
    INSERT INTO "Founders" ("FIO", number_phone, seria_passport, number_passport, "PK_Company")
    VALUES (founder_fio, founder_number_phone, founder_seria_passport, founder_number_passport, added_company_id);

    --добавляем ответственного
    INSERT INTO "ResponsibleSotrud" ("FIO", number, seria_passport, number_passport, type_activity, "PK_Company")
    VALUES (employee_fio, employee_number_phone, employee_seria_passport, employee_number_passport,
            employee_type_activity, added_company_id);
END;
$$ LANGUAGE plpgsql;


-- процедура: добавление нового датчика газа с производителем
CREATE OR REPLACE PROCEDURE add_gas_sensor(
    --датчик
    sensor_name varchar(50),
    sensor_sensitivity integer,
    sensor_mark varchar(50),
    -- производитель
    brand_name varchar(50),
    --устройство
    device_long_life date,
    device_date_installed date,
    device_date_last_serv date,
    device_serial_number varchar(50),
    -- компания
    company_id integer,
    OUT added_sensor_id integer)
AS
$$
DECLARE
    tmp      INTEGER;
    brand_id INTEGER;
BEGIN
    -- проверка на существование компании
    SELECT "PK_Company"
    INTO tmp
    FROM "Company"
    WHERE "PK_Company" = company_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Компании с таким ID не существует!';
    END IF;

    -- добавляем производителя
    INSERT INTO "Brand" ("name")
    VALUES (brand_name)
    RETURNING "PK_Brand" INTO brand_id;

    -- добавляем датчик
    INSERT INTO "SensorGas" ("name", "sensetivity", "marks", "PK_Brand")
    VALUES (sensor_name, sensor_sensitivity, sensor_mark, brand_id)
    RETURNING "PK_SensorGase" INTO added_sensor_id;

    -- добавляем устройство
    INSERT INTO "Device" ("long_life", "data_installed", "date_lastServ", "PK_Company", "PK_SensorGase",
                          "PK_SensorWater", "serial_number")
    VALUES (device_long_life, device_date_installed, device_date_last_serv, company_id, added_sensor_id, NULL,
            device_serial_number);
END ;
$$ LANGUAGE plpgsql;


-- процедура: добавление нового датчика воды с производителем
CREATE OR REPLACE PROCEDURE add_water_sensor(
    --датчик
    sensor_name varchar(50),
    sensor_sensitivity integer,
    sensor_mark varchar(50),
    -- производитель
    brand_name varchar(50),
    --устройство
    device_long_life date,
    device_date_installed date,
    device_date_last_serv date,
    device_serial_number varchar(50),
    -- компания
    company_id integer,
    OUT added_sensor_id integer)
AS
$$
DECLARE
    tmp      INTEGER;
    brand_id INTEGER;
BEGIN
    -- проверка на существование компании
    SELECT "PK_Company"
    INTO tmp
    FROM "Company"
    WHERE "PK_Company" = company_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Компании с таким ID не существует!';
    END IF;

    -- добавляем производителя
    INSERT INTO "Brand" ("name")
    VALUES (brand_name)
    RETURNING "PK_Brand" INTO brand_id;

    -- добавляем датчик
    INSERT INTO "SensorWater" ("name", "sensitivity", "mark", "PK_Brand")
    VALUES (sensor_name, sensor_sensitivity, sensor_mark, brand_id)
    RETURNING "PK_SensorWater" INTO added_sensor_id;

    -- добавляем устройство
    INSERT INTO "Device" ("long_life", "data_installed", "date_lastServ", "PK_Company", "PK_SensorGase",
                          "PK_SensorWater", "serial_number")
    VALUES (device_long_life, device_date_installed, device_date_last_serv, company_id, NULL, added_sensor_id,
            device_serial_number);
END ;
$$ LANGUAGE plpgsql

