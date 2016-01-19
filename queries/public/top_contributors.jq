import module namespace c = "http://28.io/modules/collections";

for $answers in c:collection("qa", "answers")
group by $user-id := $answers.user_id
let $count := count($answers)
order by $count descending
return {
  name: c:collection("users", "users")[$$.id eq $user-id].name,
  count: $count
}
