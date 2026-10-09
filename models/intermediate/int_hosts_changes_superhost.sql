{{ track_column_changes( 
    snapshot_table='src_hosts_snapshot', 
    unique_key='host_id', 
    column_to_change='is_superhost' 
) }}