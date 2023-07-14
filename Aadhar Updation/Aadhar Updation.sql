-- Create the Aadhaar table
CREATE TABLE aadhaar (
  aadhaar_number VARCHAR2(12) PRIMARY KEY,
  name VARCHAR2(100),
  address VARCHAR2(200),
  phone VARCHAR2(20)
);
-------------------------------
INSERT INTO aadhaar (aadhaar_number, name, address, phone)
VALUES ('123456789012', 'John Doe', '123 Main St', '123-456-7890');

INSERT INTO aadhaar (aadhaar_number, name, address, phone)
VALUES ('987654321098', 'Jane Smith', '456 Elm St', '987-654-3210');

INSERT INTO aadhaar (aadhaar_number, name, address, phone)
VALUES ('456789012345', 'Alice Johnson', '789 Oak Ave', '555-123-4567');

INSERT INTO aadhaar (aadhaar_number, name, address, phone)
VALUES ('890123456789', 'Bob Anderson', '321 Pine Rd', '111-222-3333');

INSERT INTO aadhaar (aadhaar_number, name, address, phone)
VALUES ('234567890123', 'Sarah Wilson', '567 Cedar Ln', '444-555-6666');

INSERT INTO aadhaar (aadhaar_number, name, address, phone)
VALUES ('567890123456', 'Michael Brown', '901 Walnut St', '777-888-9999');


--------------------------------------
--Procedure to insert data in to table

CREATE OR REPLACE PROCEDURE insert_aadhaar(
  p_aadhaar_number IN VARCHAR2,
  p_name IN VARCHAR2,
  p_address IN VARCHAR2,
  p_phone IN VARCHAR2
) AS
BEGIN
  INSERT INTO aadhaar (aadhaar_number, name, address, phone)
  VALUES (p_aadhaar_number, p_name, p_address, p_phone);
  COMMIT;
END;
/

----------------------------------------
--Procedure to update existing aadhar record

CREATE OR REPLACE PROCEDURE update_aadhaar(
  p_aadhaar_number IN VARCHAR2,
  p_name IN VARCHAR2,
  p_address IN VARCHAR2,
  p_phone IN VARCHAR2
) AS
BEGIN
  UPDATE aadhaar
  SET name = p_name,
      address = p_address,
      phone = p_phone
  WHERE aadhaar_number = p_aadhaar_number;
  COMMIT;
END;
/

----------------Procedure to delete aadhar record --------

CREATE OR REPLACE PROCEDURE delete_aadhaar(
  p_aadhaar_number IN VARCHAR2
) AS
BEGIN
  DELETE FROM aadhaar
  WHERE aadhaar_number = p_aadhaar_number;
  COMMIT;
END;
/


------------------Procedure to retrieve aadhar record ----

CREATE OR REPLACE PROCEDURE retrieve_aadhaar(
  p_aadhaar_number IN VARCHAR2,
  p_name OUT VARCHAR2,
  p_address OUT VARCHAR2,
  p_phone OUT VARCHAR2
) AS
BEGIN
  SELECT name, address, phone
  INTO p_name, p_address, p_phone
  FROM aadhaar
  WHERE aadhaar_number = p_aadhaar_number;
END;
/

---------Fetching records-------------

SET SERVEROUTPUT ON

DECLARE
  v_name aadhaar.name%TYPE;
  v_address aadhaar.address%TYPE;
  v_phone aadhaar.phone%TYPE;
BEGIN
  -- Retrieve a record
  retrieve_aadhaar('123456789012', v_name, v_address, v_phone);
  DBMS_OUTPUT.PUT_LINE('Name: ' || v_name);
  DBMS_OUTPUT.PUT_LINE('Address: ' || v_address);
  DBMS_OUTPUT.PUT_LINE('Phone: ' || v_phone);
  DBMS_OUTPUT.PUT_LINE('');

  -- Update a record
  update_aadhaar('123456789012', 'John Doe Jr.', '456 Oak St', '555-789-0123');
  retrieve_aadhaar('123456789012', v_name, v_address, v_phone);
  DBMS_OUTPUT.PUT_LINE('Updated Name: ' || v_name);
  DBMS_OUTPUT.PUT_LINE('Updated Address: ' || v_address);
  DBMS_OUTPUT.PUT_LINE('Updated Phone: ' || v_phone);
  DBMS_OUTPUT.PUT_LINE('');

  -- Delete a record
  delete_aadhaar('567890123456');
  retrieve_aadhaar('567890123456', v_name, v_address, v_phone);
  DBMS_OUTPUT.PUT_LINE('Deleted Record: ' || v_name);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Record not found.');
END;
/


-----Fetch records using Cursor-------------

SET SERVEROUTPUT ON

DECLARE
  CURSOR c_aadhaar IS
    SELECT aadhaar_number, name, address, phone
    FROM aadhaar;
  v_aadhaar_number aadhaar.aadhaar_number%TYPE;
  v_name aadhaar.name%TYPE;
  v_address aadhaar.address%TYPE;
  v_phone aadhaar.phone%TYPE;
BEGIN
  OPEN c_aadhaar;
  LOOP
    FETCH c_aadhaar INTO v_aadhaar_number, v_name, v_address, v_phone;
    EXIT WHEN c_aadhaar%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Aadhaar Number: ' || v_aadhaar_number);
    DBMS_OUTPUT.PUT_LINE('Name: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('Address: ' || v_address);
    DBMS_OUTPUT.PUT_LINE('Phone: ' || v_phone);
    DBMS_OUTPUT.PUT_LINE('');
  END LOOP;
  CLOSE c_aadhaar;
END;
/
