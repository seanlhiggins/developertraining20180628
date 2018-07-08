view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_tier {
    type: tier
    sql: ${age} ;;
    tiers: [18,35,45,60]
    style: integer
  }

  dimension: is_under_40 {
    type: yesno
    sql: ${age} < 40  ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,day_of_week,
      week,
      month,month_name,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: days_since_signup {
    type: number
    sql: DATEDIFF(day, ${created_date}, current_date) ;;
  }

  dimension: is_new_user {
    type: yesno
    sql: ${days_since_signup} < 7 ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count_users_under_40 {
    type: count
    filters: {
      field: is_under_40
      value: "yes"
    }
  }

  measure: count_new_users {
    type: count
    filters: {
      field: is_new_user
      value: "yes"
    }
  }
  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }

  measure: percent_users_under_40 {
    type: number
    sql: 1.0 * ${count_users_under_40} / nullif(${count},0) ;;
    value_format_name: percent_2
  }

}
