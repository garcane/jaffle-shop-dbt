select
id as payment_id,
orderid as order_id,
    PAYMENTMETHOD,
    status,
    AMOUNT / 100 as amount,
    CREATED,
    _BATCHED_AT


from {{ source('stripe', 'payment') }}
