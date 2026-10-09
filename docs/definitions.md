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

{# ---- Columns produced by the track_column_changes macro ---- #}

{% docs change_event_id %}
Surrogate key for the row, generated from the entity key, the tracked column's value, and dbt_valid_from.
{% enddocs %}

{% docs change_grp %}
Sequence number of the state for this entity. Starts at 1 and increases by 1 each time the tracked column changes.
{% enddocs %}

{% docs change_valid_from %}
Timestamp this state took effect, the earliest dbt_valid_from in the period.
{% enddocs %}

{% docs change_valid_to %}
Timestamp this state ended, the latest dbt_valid_to in the period. 9999-12-31 means it is still current.
{% enddocs %}

{# ---- Macro arguments ---- #}

{% docs macro_node_arg %}
The node being built, supplied by dbt and unused here.
{% enddocs %}
