explore:sql_runner_query{}
view: sql_runner_query {
  derived_table: {
    sql: SELECT *,answer_value * weighted_count as AV_times_WC FROM ( SELECT 1 as answer_value,436 as weighted_count
      UNION
      SELECT 2 as answer_value,680
       as weighted_count
      UNION
      SELECT 3 as answer_value,311
       as weighted_count
      UNION
      SELECT 4 as answer_value,85
       as weighted_count)
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: answer_value {
    type: number
    sql: ${TABLE}.answer_value ;;
  }

  dimension: weighted_count {
    type: number
    sql: ${TABLE}.weighted_count ;;
  }

  measure: total_weighted_count {
    type: sum
    sql: ${weighted_count} ;;
  }
  measure: av_times_wc {
    type: number
    sql: ${TABLE}.av_times_wc ;;
  }
  measure: av_times_wc_measure {
    type: number
    sql: ${answer_value} * ${weighted_count} ;;
  }

  set: detail {
    fields: [answer_value, weighted_count, av_times_wc]
  }
}
