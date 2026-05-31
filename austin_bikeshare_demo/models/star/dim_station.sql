WITH trip_start_metrics AS (
    SELECT
        start_station_id AS station_id,
        AVG(duration_minutes * 60) AS avg_duration
    FROM {{ ref('fact_trips') }}
    GROUP BY start_station_id
)

SELECT
    station.station_id,
    station.name,
    station.location,
    station.address,
    station.property_type,
    station.number_of_docks,
    trip_start_metrics.avg_duration,
    station.dbt_valid_from,
    station.dbt_valid_to
FROM {{ ref('station_snapshot') }} AS station
LEFT JOIN trip_start_metrics
    ON CAST(station.station_id AS STRING) = CAST(trip_start_metrics.station_id AS STRING)
