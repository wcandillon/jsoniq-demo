import module namespace mongo = "http://www.28msec.com/modules/mongodb";
import module namespace jdbc = "http://www.28msec.com/modules/jdbc";
import module namespace credentials = "http://www.28msec.com/modules/credentials";

variable $stack := mongo:connect(credentials:credentials("MongoDB", "stackoverflow"));
variable $users := mongo:connect(credentials:credentials("MongoDB", "users"));
(:
  variable $qa := mongo:connect(credentials:credentials("JDBC", "qa"));
:)

for $answer in (mongo:find($stack, "answers"), mongo:find($stack, "faq"))
where exists($answer.owner.user_id)
group by $id := $answer.owner.user_id
let $user := $answer[1].owner
let $user := copy $q := $user
               modify delete json $q.user_id
               return $q
let $user := {| $user, { id: $id, name: $user.display_name } |}
return mongo:save($users, "users", $user);

(:
for $answer in mongo:find($stack, "answers")
where exists($answer.owner.user_id)
let $id := $answer.owner.user_id
let $answer := copy $q := $answer
               modify delete json $q.owner
               return $q
let $answer := {| $answer, { user_id: $id } |}
return "INSERT INTO answers (id, user_id, question_id, creation_date, score, is_accepted) VALUES (" || $answer.answer_id || ", " || $id || ", " || $answer.question_id || ", '" || $answer.creation_date || "', " || $answer.score || ", " || $answer.is_accepted || ");
"
:)

(:
for $answer in mongo:find($stack, "faq")
where exists($answer.owner)
let $id := $answer.owner.user_id
let $answer := copy $q := $answer
               modify delete json $q.owner
               return $q
let $answer := {| $answer, { user_id: $id } |}
return "INSERT INTO questions (id, user_id, creation_date, score, accepted_answer_id, title, link) VALUES (" || $answer.question_id || ", " || $id || ", '" || $answer.creation_date || "', " || $answer.score || ", " || (if($answer.accepted_answer_id) then $answer.accepted_answer_id else null) || ", '" || $answer.title || "', '" || $answer.link || "');
"
:)
