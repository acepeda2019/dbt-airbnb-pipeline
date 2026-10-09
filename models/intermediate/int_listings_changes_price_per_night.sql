{{ track_column_changes( 
    snapshot_table='src_listings_snapshot', 
    unique_key='listing_id', 
    column_to_change='price_per_night' 
) }}