import module namespace c = "http://28.io/modules/collections";

for $answer in c:collection("qa", "answers")
group by $user-id := $answer.user_id
let $user := c:collection("users", "users")[$$.id eq $user-id]
let $avg-rep := avg($user.reputation)
order by $avg-rep descending empty least
return {
  name    : $user.name,
  avg-rep : floor($avg-rep)
}
