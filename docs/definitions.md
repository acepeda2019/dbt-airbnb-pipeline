{# Shared definitions, referenced from YAML files with "{{ doc('name') }}" #}

{# ---- Entity keys ---- #}

{% docs booking_id %}
Unique identifier of a booking.
{% enddocs %}

{% docs listing_id %}
Unique identifier of a listing.
{% enddocs %}

{% docs host_id %}
Unique identifier of a host.
{% enddocs %}

{# ---- Shared columns ---- #}

{% docs booking_status %}
Status of the booking.
{% enddocs %}

{% docs is_superhost %}
Whether the host has superhost status.
{% enddocs %}

{% docs response_rate %}
Host's response rate to guest enquiries.
{% enddocs %}

{% docs price_per_night %}
Nightly price of the listing.
{% enddocs %}

{% docs created_at %}
Timestamp the source record was created.
{% enddocs %}

{# ---- Booking, host and listing attributes ---- #}

{% docs booking_date %}
Timestamp the booking was made.
{% enddocs %}

{% docs nights_booked %}
Number of nights in the booking.
{% enddocs %}

{% docs booking_amount %}
Booking amount before fees, multiplied by nights_booked to calculate total_revenue.
{% enddocs %}

{% docs cleaning_fee %}
Cleaning fee charged on the booking.
{% enddocs %}

{% docs service_fee %}
Service fee charged on the booking.
{% enddocs %}

{% docs total_fees %}
Sum of cleaning_fee and service_fee.
{% enddocs %}

{% docs total_revenue %}
nights_booked multiplied by booking_amount (rounded to 4 decimal places), plus total_fees.
{% enddocs %}

{% docs host_name %}
Name of the host, upper-cased and trimmed in staging.
{% enddocs %}

{% docs host_since %}
Date the host joined the platform.
{% enddocs %}

{% docs is_seasoned_host %}
Hosts that have been on the platform for at least 12 months.
{% enddocs %}

{% docs property_type %}
Type of property, upper-cased and trimmed in staging.
{% enddocs %}

{% docs room_type %}
Type of room offered, upper-cased and trimmed in staging.
{% enddocs %}

{% docs city %}
City the listing is in, upper-cased and trimmed in staging.
{% enddocs %}

{% docs country %}
Country the listing is in, upper-cased and trimmed in staging.
{% enddocs %}

{% docs accommodates %}
Number of guests the listing accommodates.
{% enddocs %}

{% docs bedrooms %}
Number of bedrooms.
{% enddocs %}

{% docs bathrooms %}
Number of bathrooms.
{% enddocs %}

{% docs is_backfilled_flag %}
Flag is true when booking date pre-dates the valid_from date. In this case the first known state used rather than exact state at booking.
{% enddocs %}

{# ---- Columns produced by the track_column_changes macro ---- #}

{% docs change_event_id %}
Surrogate key for the row, generated from the entity key, the tracked column's value, and dbt_valid_from.
{% enddocs %}

{% docs change_grp %}
Sequence number of the state for this entity. Starts at 1 and increases by 1 each time the tracked column changes.
{% enddocs %}

{% docs change_valid_from %}
Timestamp this state was extracted from the source, the earliest dbt_valid_from in the period.
{% enddocs %}

{% docs change_valid_to %}
Timestamp this state ended, the latest dbt_valid_to in the period. 9999-12-31 means it is still current.
{% enddocs %}

{# ---- Macro arguments ---- #}

{% docs macro_node_arg %}
The node being built, supplied by dbt and unused here.
{% enddocs %}
