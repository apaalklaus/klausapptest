with

conversations as (

    select * from {{ ref('stg_klaus__conversations' ) }}

),

autoqa_reviews as  (

    select * from {{ ref('stg_klaus__autoqa_reviews' ) }}

),

manual_reviews as (

    select * from {{ ref('stg_klaus__manual_reviews') }}

),

autoqa_ratings as (

    select * from {{ ref('stg_klaus__autoqa_ratings') }} 

),

prep_autoqa_reviews as (

    select 
        autoqa_review_id as review_id, 
        'autoqa' as review_type, 
        external_ticket_id,
        reviewee_user_id,
        team_id,
        date(created_at) as review_created_at_date
    from autoqa_reviews

),

prep_manual_reviews as (

    select 
        {{ dbt_utils.generate_surrogate_key(['review_id', "'manual'"]) }} as review_id, 
        'manual' as review_type, 
        conversation_external_id as external_ticket_id,
        reviewee_user_id,
        team_id,
        date(created_at) as review_created_at_date,
        round(score_pct, 2) as score_pct,
        if(score_pct >= 50, true, false) as is_review_passed
    from manual_reviews

),

prep_autoqa_ratings as (
    
    select 
        autoqa_review_id as review_id,
        score_pct,
        rating_category_name,
        rating_scale_score,
        1 as score_weight
    from autoqa_ratings
    --ignore nulls since they are likely selected to be ignored from Klaus UI
    where score_pct is not null

),

agg_autoqa_ratings as (

    select 
        review_id,
        round(sum(score_pct * score_weight) / sum(score_weight), 2) as score_pct
    from prep_autoqa_ratings
    group by 1

),

join_autoqa_reviews_to_autoqa_ratings as (

    select 
        prep_autoqa_reviews.*,
        agg_autoqa_ratings.score_pct,
        if(score_pct >= 50, true, false) as is_review_passed
    from prep_autoqa_reviews
    left join agg_autoqa_ratings
        on prep_autoqa_reviews.review_id = agg_autoqa_ratings.review_id

),

union_autoqa_and_manual_reviews as (

    select * from join_autoqa_reviews_to_autoqa_ratings
    union all 
    select * from prep_manual_reviews

)


select * from union_autoqa_and_manual_reviews where score_pct is not null
