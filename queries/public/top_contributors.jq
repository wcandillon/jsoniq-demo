import module namespace c = "http://28.io/modules/collections";

(:
 : Users who answered the most questions.
 :)
for $answer in c:collection("qa", "answers")
group by $user-id := $answer.user_id
let $count := count($answer)
order by $count descending
return {
  name  : c:collection("users", "users")[$$.id eq $user-id].name,
  count : $count
}
