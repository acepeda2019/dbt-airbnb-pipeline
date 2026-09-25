-- DDL For My Tables
CREATE OR REPLACE TABLE HOSTS (
    host_id NUMBER,
    host_name STRING,
    host_since DATE,
    is_superhost BOOLEAN,
    response_rate NUMBER,
    created_at TIMESTAMP,
    PRIMARY KEY (host_id)
);

CREATE OR REPLACE TABLE LISTINGS (
    listing_id NUMBER,
    host_id NUMBER,
    property_type STRING,
    room_type STRING,
    city STRING,
    country STRING,
    accommodates NUMBER,
    bedrooms NUMBER,
    bathrooms NUMBER,
    price_per_night NUMBER,
    created_at TIMESTAMP,
    PRIMARY KEY (listing_id)
);

CREATE OR REPLACE TABLE BOOKINGS (
    booking_id STRING,
    listing_id NUMBER,
    booking_date TIMESTAMP,
    nights_booked NUMBER,
    booking_amount NUMBER,
    cleaning_fee NUMBER,
    service_fee NUMBER,
    booking_status STRING,
    created_at TIMESTAMP,
    PRIMARY KEY (booking_id)
);



CREATE OR REPLACE FILE FORMAT IF NOT EXISTS csv_format
  TYPE = 'CSV'
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE;

CREATE OR REPLACE STAGE snowstage
FILE_FORMAT = csv_format
URL='s3://airbnb-640122370875-us-west-2/raw/';

-- Swap in your own IAM user's key pair before running (never commit real values here)
COPY INTO BOOKINGS
FROM @snowstage
FILES=('bookings.csv')
CREDENTIALS=(aws_key_id = '<AWS_ACCESS_KEY_ID>', aws_secret_key = '<AWS_SECRET_ACCESS_KEY>');

COPY INTO HOSTS
FROM @snowstage
FILES=('hosts.csv')
CREDENTIALS=(aws_key_id = '<AWS_ACCESS_KEY_ID>', aws_secret_key = '<AWS_SECRET_ACCESS_KEY>');

COPY INTO LISTINGS
FROM @snowstage
FILES=('listings.csv')
CREDENTIALS=(aws_key_id = '<AWS_ACCESS_KEY_ID>', aws_secret_key = '<AWS_SECRET_ACCESS_KEY>');