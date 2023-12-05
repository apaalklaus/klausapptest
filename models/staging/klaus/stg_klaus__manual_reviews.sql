with 

source as (

    select * from {{ source('klaus', 'manual_reviews') }}

),

renamed as (

    select
        -- ids 
        review_id,
        payment_id,
        payment_token_id,
        team_id,
        reviewer_id as reviewer_user_id,
        reviewee_id as reviewee_user_id,
        conversation_external_id,
        updated_by as updated_by_user_id,
        comment_id,
        scorecard_id,

        -- strings
        scorecard_tag,

        -- numbers
        score,
        
        -- boolean
        assignment_review as is_assignment_review,
        seen as is_seen,
        disputed as is_disputed,

        --durations
        review_time_seconds,

        -- dates
        cast(conversation_created_date as date) as conversation_created_date,

        -- timestamps
        cast(created as timestamp) as created_at,
        cast(conversation_created_at as timestamp) as conversation_created_at,
        cast(updated_at as timestamp) as updated_at,
        cast(imported_at as timestamp) as imported_at

    from source

)

select * from renamed
