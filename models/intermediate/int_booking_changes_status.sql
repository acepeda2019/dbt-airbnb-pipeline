{{ track_column_changes( 
    snapshot_table='src_bookings_snapshot', 
    unique_key='booking_id', 
    column_to_change='booking_status' 
) }}