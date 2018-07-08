view: user_order_facts {
  derived_table: {
    datagroup_trigger: training20180628_default_datagroup
    sql: SELECT
        order_items.user_id as user_id
        , COUNT(DISTINCT order_items.order_id) as lifetime_orders
        , SUM(order_items.sale_price) AS lifetime_revenue
        , MIN(NULLIF(order_items.created_at,0)) as first_order
        , MAX(NULLIF(order_items.created_at,0)) as latest_order
        , COUNT(DISTINCT DATE_TRUNC('month', NULLIF(order_items.created_at,0))) as number_of_distinct_months_with_orders
        , SUM(order_items.sale_price) AS order_value
      FROM order_items
      GROUP BY user_id
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  measure: lifetime_orders {
    type: sum
    sql: ${TABLE}.lifetime_orders ;;
  }

  measure: lifetime_revenue {
    type: sum
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension_group: first_order {
    type: time
    sql: ${TABLE}.first_order ;;
  }

  dimension_group: latest_order {
    type: time
    sql: ${TABLE}.latest_order ;;
  }

  measure: number_of_distinct_months_with_orders {
    type: sum
    sql: ${TABLE}.number_of_distinct_months_with_orders ;;
  }

  measure: order_value {
    type: sum
    sql: ${TABLE}.order_value ;;
  }

  set: detail {
    fields: [
      user_id,
      lifetime_orders,
      lifetime_revenue,
      first_order_time,
      latest_order_time,
      number_of_distinct_months_with_orders,
      order_value
    ]
  }
}
