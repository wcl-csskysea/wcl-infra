.Data.Items.Item
  | map(
      # Convert Tag from string to object
      # e.g. {"Tag": "key:role value:db; key:cust value:company; key:env value:qa"}
      .Tag = (
        .Tag                              # "key:role value:db; key:cust value:company; key:env value:qa"
          | split("; ")                   # ["key:role value:db","key:cust value:company","key:env value:prod"]
          | map(                          #   "key:role value:db"
              split(" ")                  #   ["key:role","value:db"]
                | map(split(":") | .[1])  #   ["role","db"]
                | { (.[0]): .[1] }        #   {"role":"db"}
            )                             # [{"role":"db"},{"cust":"company"},{"env":"qa"}]
          | add                           # {"role":"db","cust":"company","env":"qa"}
      )
    )
  | map({
      Customer: (.Tag.cust // .Tag.customer),
      Environment: .Tag.env,
      ProductCode,
      PaymentAmount,
    })
  | map(select(.Customer)) # Only take into consideration resources with cust tag
  | group_by(.Customer, .Environment)  # Group by cust-env tags
  | add   # Remove the nesting introduced by group_by
