
-- 1. Function:
CREATE OR REPLACE FUNCTION search_pattern(pattern TEXT)
RETURNS TABLE(id INT, username VARCHAR, phone VARCHAR)
AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM phonebook p
    WHERE p.username ILIKE '%' || pattern || '%'
       OR p.phone ILIKE '%' || pattern || '%';
END;
$$ LANGUAGE plpgsql;


-- 2. Procedure: 
CREATE OR REPLACE PROCEDURE insert_or_update_user(_username TEXT, _phone TEXT)
AS $$
DECLARE
    user_exists BOOLEAN;
BEGIN
    -- Validate phone: 
    IF _phone ~ '^\d{10,15}$' THEN
        -- Check if user exists
        SELECT EXISTS (
            SELECT 1 FROM phonebook WHERE username = _username
        ) INTO user_exists;

        -- Insert or update
        IF user_exists THEN
            UPDATE phonebook SET phone = _phone WHERE username = _username;
            RAISE NOTICE 'Updated: % -> %', _username, _phone;
        ELSE
            INSERT INTO phonebook(username, phone) VALUES (_username, _phone);
            RAISE NOTICE 'Inserted: % -> %', _username, _phone;
        END IF;
    ELSE
        RAISE NOTICE 'Invalid phone number for %: % (must be digits only and 10–15 chars)', _username, _phone;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- 3. Procedure: 
CREATE OR REPLACE PROCEDURE insert_many_users(names TEXT[], phones TEXT[])
AS $$
DECLARE
    i INT := 1;
    uname TEXT;
    uphone TEXT;
BEGIN
    WHILE i <= array_length(names, 1) LOOP
        uname := names[i];
        uphone := phones[i];

        IF uphone ~ '^\d{10,15}$' THEN
            -- Проверка, существует ли пользователь
            IF EXISTS (SELECT 1 FROM phonebook WHERE username = uname) THEN
                -- Обновление номера телефона
                UPDATE phonebook SET phone = uphone WHERE username = uname;
            ELSE
                -- Вставка нового пользователя
                INSERT INTO phonebook (username, phone) VALUES (uname, uphone);
            END IF;
            RAISE NOTICE 'Saved: % - %', uname, uphone;
        ELSE
            RAISE NOTICE 'Invalid phone for %: %', uname, uphone;
        END IF;

        i := i + 1;
    END LOOP;
END;
$$ LANGUAGE plpgsql;


-- 4. Function:
CREATE OR REPLACE FUNCTION paginate_users(_limit INT, _offset INT)
RETURNS TABLE(id INT, username VARCHAR, phone VARCHAR)
AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM phonebook
    ORDER BY id
    LIMIT _limit OFFSET _offset;
END;
$$ LANGUAGE plpgsql;

-- 5. Procedure:
CREATE OR REPLACE PROCEDURE delete_user(_value TEXT)
AS $$
BEGIN
    DELETE FROM phonebook WHERE username = _value OR phone = _value;
    RAISE NOTICE 'Deleted rows with value: %', _value;
END;
$$ LANGUAGE plpgsql;