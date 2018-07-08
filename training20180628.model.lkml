connection: "events_ecommerce"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

datagroup: training20180628_default_datagroup {
  sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}
persist_with: training20180628_default_datagroup

datagroup: live_cache {
  max_cache_age: "1 minute"
}

explore: distribution_centers {
  persist_with: live_cache
}

explore: etl_jobs {}

explore: events {
  persist_with: live_cache
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: order_items_2 {
  from:order_items
  fields: [ALL_FIELDS*,-order_items_2.profit]
  }

explore: foo {}

explore: inventory_items {
  group_label: "Ecommerce"
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {

  sql_always_having: ${total_revenue} > 500 ;;

  group_label: "Ecommerce"
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: users {
  join: user_order_facts {
    type: left_outer
    sql_on: ${users.id} = ${user_order_facts.user_id} ;;
    relationship: one_to_one
  }

}
