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