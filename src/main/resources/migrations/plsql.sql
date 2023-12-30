-- Триггер, срабатывающий при добавлении данных в таблицу "LogGas".
CREATE OR REPLACE FUNCTION write_incident_on_log_gas_over_limit()
    RETURNS TRIGGER AS
$$
BEGIN
    DECLARE
        company_norm_gas_emission REAL;
        company_id                INTEGER;
        curr_company_name         VARCHAR;
        curr_gas_emission         REAL;
        curr_device_serial_number VARCHAR;
        curr_founder_fio          VARCHAR;
        curr_employee_fio         VARCHAR;
        gas_concentrate           INTEGER;
    BEGIN
        -- получаем id, наименование и норму газа предприятия, показания для которого записываем
        SELECT c."PK_Company", c."norm_gas_emission", c."name", d."serial_number"
        INTO company_id, company_norm_gas_emission, curr_company_name, curr_device_serial_number
        FROM "Device" d
                 JOIN "Company" c ON d."PK_Company" = c."PK_Company"
        WHERE d."PK_Device" = NEW."PK_Device";

        -- получаем информацию о сотрудниках
        SELECT f."FIO"
        INTO curr_founder_fio
        FROM "Founders" f
        WHERE f."PK_Company" = company_id;

        SELECT r."FIO"
        INTO curr_employee_fio
        FROM "ResponsibleSotrud" r
        WHERE r."PK_Company" = company_id;

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

        IF curr_gas_emission + (NEW."Indicator" * gas_concentrate) > company_norm_gas_emission
            OR curr_gas_emission IS NULL AND NEW."Indicator" * gas_concentrate > company_norm_gas_emission THEN
            INSERT INTO "Incidents" (incident_date, log_water, log_gas, company_name, founder_fio,
                                     responsible_employee_fio, device_serial_number)
            VALUES (current_date, null, NEW."Indicator", curr_company_name, curr_founder_fio, curr_employee_fio,
                    curr_device_serial_number);
        END IF;
    END;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER write_incident_on_log_gas_over_limit_trigger
    BEFORE INSERT
    ON "LogGas"
    FOR EACH ROW
EXECUTE PROCEDURE write_incident_on_log_gas_over_limit();


-- Триггер, срабатывающий при добавлении данных в таблицу "LogWater".
CREATE OR REPLACE FUNCTION write_incident_on_log_water_over_limit()
    RETURNS TRIGGER AS
$$
BEGIN
    DECLARE
        company_norm_water_emission REAL;
        company_id                  INTEGER;
        curr_water_emission         REAL;
        curr_company_name           VARCHAR;
        curr_device_serial_number   VARCHAR;
        curr_founder_fio            VARCHAR;
        curr_employee_fio           VARCHAR;
    BEGIN
        -- получаем id и норму газа предприятия, показания для которого записываем
        SELECT c."PK_Company", c."norm_water_emisson", c."name", d."serial_number"
        INTO company_id, company_norm_water_emission, curr_company_name, curr_device_serial_number
        FROM "Device" d
                 JOIN "Company" c ON d."PK_Company" = c."PK_Company"
        WHERE d."PK_Device" = NEW."PK_Device";

        -- получаем информацию о сотрудниках
        SELECT f."FIO"
        INTO curr_founder_fio
        FROM "Founders" f
        WHERE f."PK_Company" = company_id;

        SELECT r."FIO"
        INTO curr_employee_fio
        FROM "ResponsibleSotrud" r
        WHERE r."PK_Company" = company_id;

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

        IF curr_water_emission + NEW."Indecator" > company_norm_water_emission
            OR curr_water_emission IS NULL AND NEW."Indecator" > company_norm_water_emission THEN
            INSERT INTO "Incidents" (incident_date, log_water, log_gas, company_name, founder_fio,
                                     responsible_employee_fio, device_serial_number)
            VALUES (current_date, NEW."Indecator", null, curr_company_name, curr_founder_fio, curr_employee_fio,
                    curr_device_serial_number);
        END IF;
    END;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER write_incident_on_log_water_over_limit_trigger
    BEFORE INSERT
    ON "LogWater"
    FOR EACH ROW
EXECUTE PROCEDURE write_incident_on_log_water_over_limit();

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
    SELECT "PK_Type_Company"
    INTO type_id
    FROM "Type_Company"
    WHERE "name" = type_name;

    IF NOT FOUND THEN
        INSERT INTO "Type_Company" ("name")
        VALUES (type_name)
        RETURNING "PK_Type_Company" INTO type_id;
    END IF;

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

    -- проверка на существование производителя
    SELECT "PK_Brand"
    INTO brand_id
    FROM "Brand"
    WHERE "name" = brand_name;

    IF NOT FOUND THEN
        INSERT INTO "Brand" ("name")
        VALUES (brand_name)
        RETURNING "PK_Brand" INTO brand_id;
    END IF;

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

    -- проверка на существование производителя
    SELECT "PK_Brand"
    INTO brand_id
    FROM "Brand"
    WHERE "name" = brand_name;

    IF NOT FOUND THEN
        INSERT INTO "Brand" ("name")
        VALUES (brand_name)
        RETURNING "PK_Brand" INTO brand_id;
    END IF;

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
$$ LANGUAGE plpgsql;


-- процедура, генерирующая показания датчиков для компании
CREATE OR REPLACE PROCEDURE generate_logs(company_id integer)
AS
$$
DECLARE
    water_device_ids INTEGER[];
    water_sensor_id  INTEGER;
    gas_device_ids   INTEGER[];
    gas_sensor_id    INTEGER;
    pollution_gas_id INTEGER;
    i                INTEGER;
    j                INTEGER;
BEGIN
    --Добавляем лог воды
    SELECT ARRAY(
                   SELECT "PK_Device"
                   FROM "Device"
                   WHERE "PK_Company" = company_id
                     AND "PK_SensorWater" IS NOT NULL)
    INTO water_device_ids;

    IF array_length(water_device_ids, 1) IS NULL THEN
        FOR i IN 1..floor(random() * (100 - 30) + 30)
            LOOP
                CALL add_water_sensor(
                        ('water sensor' || i)::varchar(50),
                        floor(random() * (3 - 1) + 1)::integer,
                        'water sensor mark',
                        'water brand',
                        '2025-01-01',
                        CURRENT_DATE,
                        CURRENT_DATE,
                        ('watersensor12' || i)::varchar(50),
                        company_id,
                        water_sensor_id);
            END LOOP;

        SELECT ARRAY(
                       SELECT "PK_Device"
                       FROM "Device")
        INTO water_device_ids;
    END IF;

    FOR i IN 1..array_length(water_device_ids, 1)
        LOOP
            FOR j IN 1..30
                LOOP
                    INSERT INTO "LogWater" ("PK_Device", "date_lastUpdate", "Indecator")
                    VALUES (water_device_ids[i], CURRENT_DATE - (30 - j), random() * 100);
                END LOOP;
        END LOOP;


    -- добавляем лог воздуха
    SELECT ARRAY(
                   SELECT "PK_Device"
                   FROM "Device"
                   WHERE "PK_Company" = company_id
                     AND "PK_SensorGase" IS NOT NULL)
    INTO gas_device_ids;

    IF array_length(gas_device_ids, 1) IS NULL THEN
        FOR i IN 1..floor(random() * (100 - 30) + 30)
            LOOP
                CALL add_gas_sensor(
                        ('gas sensor ' || i)::varchar(50),
                        floor(random() * (3 - 1) + 1)::integer,
                        'gas sensor mark',
                        'gas brand',
                        '2025-01-01',
                        CURRENT_DATE,
                        CURRENT_DATE,
                        ('gassensor' || i)::varchar(50),
                        company_id,
                        gas_sensor_id);
            END LOOP;

        SELECT ARRAY(
                       SELECT "PK_Device"
                       FROM "Device")
        INTO gas_device_ids;
    END IF;

    FOR i IN 1..array_length(gas_device_ids, 1)
        LOOP
            FOR j IN 1..30
                LOOP
                    SELECT "PK_PollutionGases"
                    INTO pollution_gas_id
                    FROM "PollutionGases"
                    ORDER BY random()
                    LIMIT 1;

                    INSERT INTO "LogGas" ("PK_Device", "date_lastUpdate", "Indicator", "PK_PollutionGases")
                    VALUES (gas_device_ids[i], CURRENT_DATE - (30 - j), random() * 100, pollution_gas_id);
                END LOOP;
        END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Удаление устройства по id
CREATE OR REPLACE PROCEDURE delete_device_cascade(device_id integer)
AS
$$
DECLARE
    sensor_gas_id   INTEGER;
    sensor_water_id INTEGER;
BEGIN
    DELETE FROM "LogWater" WHERE "PK_Device" = device_id;
    DELETE FROM "LogGas" WHERE "PK_Device" = device_id;

    DELETE FROM "Device" WHERE "PK_Device" = device_id;

    SELECT "PK_SensorGase"
    INTO sensor_gas_id
    FROM "Device"
    WHERE "PK_Device" = device_id;
    IF sensor_gas_id IS NOT NULL THEN
        DELETE FROM "SensorGas" WHERE "PK_SensorGase" = sensor_gas_id;
    END IF;

    SELECT "PK_SensorWater"
    INTO sensor_water_id
    FROM "Device"
    WHERE "PK_Device" = device_id;
    IF sensor_water_id IS NOT NULL THEN
        DELETE FROM "SensorWater" WHERE "PK_SensorWater" = sensor_water_id;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Удаление компании по id
CREATE OR REPLACE PROCEDURE delete_company_cascade(company_id integer)
AS
$$
DECLARE
    devices_ids INTEGER[];
BEGIN
    DELETE FROM "Founders" WHERE "PK_Company" = company_id;
    DELETE FROM "ResponsibleSotrud" WHERE "PK_Company" = company_id;
    DELETE FROM "Type_Company-Company" WHERE "PK_Company" = company_id;

    SELECT ARRAY(
                   SELECT "PK_Device"
                   FROM "Device"
                   WHERE "PK_Company" = company_id)
    INTO devices_ids;
    IF array_length(devices_ids, 1) IS NOT NULL THEN
        FOR i IN 1..array_length(devices_ids, 1)
            LOOP
                CALL delete_device_cascade(devices_ids[i]);
            END LOOP;
    END IF;

    DELETE FROM "Company" WHERE "PK_Company" = company_id;
END;
$$ LANGUAGE plpgsql;

