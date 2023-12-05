with 

source as (

    select * from {{ source('klaus', 'conversations') }}

),

renamed as (

    select
        -- ids
        payment_id,
        payment_token_id,
        external_ticket_id,
        assignee_id,
        most_active_internal_user_id,
        agent_most_public_messages as most_public_messages_agent_id,

        --strings
        channel,
        language as language_short,
        lower(klaus_sentiment) as klaus_sentiment_name,

        -- boolean
        is_closed,
        if(klaus_sentiment = 'POSITIVE', true, false) as is_klaus_sentiment_positive,
        if(deleted_at is not null, true, false) as is_deleted,

        -- numbers
        message_count,
        unique_public_agent_count,
        public_mean_character_count,
        public_mean_word_count,
        private_message_count,
        public_message_count,

        -- durations
        first_response_time as first_response_time_seconds,        
        first_resolution_time_seconds,
        full_resolution_time_seconds,

        -- dates
        cast(conversation_created_at_date as date) as conversation_created_at_date,        

        -- timestamps
        cast(conversation_created_at as timestamp) as conversation_created_at,
        cast(updated_at as timestamp) as updated_at,
        --this was turned into int64 when using dbt seed. all values are NULL. this will save column as timestamp
        cast(timestamp_millis(deleted_at) as timestamp) as deleted_at,
        cast(closed_at as timestamp) as closed_at,
        cast(imported_at as timestamp) as imported_at,
        cast(last_reply_at as timestamp) as last_reply_at
    from source

)

select * from renamed
