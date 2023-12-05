with 

source as (

    select * from {{ source('klaus', 'autoqa_root_causes') }} 

),

renamed as (

    select
        -- ids 
        {{ dbt_utils.generate_surrogate_key(['autoqa_rating_id', 'category', 'count', 'root_cause']) }} as grain_id, 
        autoqa_rating_id,

        -- strings
        category as category_name,
        root_cause as root_cause_name,

        -- numbers
        count as root_cause_count,
    from source

),

identify_unique_rows as (
    select 
        * except(grain_id),
        row_number() over (partition by grain_id) = 1 as is_unique_row
    from renamed
)

select * from identify_unique_rows where is_unique_row = true 
