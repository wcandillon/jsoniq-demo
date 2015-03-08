import module namespace c = "http://28.io/modules/collections";

for $answers in c:collection("qa", "answers")
group by $user-id := $answers.user_id

let $answers := for $answer in $answers
                order by $answer.creation_date
                return $answer

let $streaks := for tumbling window $answers in $answers
start $start when true
end $end next $next when $next.creation_date - $end.creation_date gt dayTimeDuration("P1D")
return $end.creation_date - $start.creation_date

let $streak := max($streaks)
let $rep   := sum($answers.score)
let $count := count($answers)
order by $streak descending
return {
    "username": c:collection("users", "users")[$$.id eq $user-id].name,
    "number of answers": $count,
    "reputation": $rep,
    "largest contribution streak": days-from-duration($streak)
}
