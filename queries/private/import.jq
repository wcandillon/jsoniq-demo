import module namespace mongo = "http://www.28msec.com/modules/mongodb";
import module namespace jdbc = "http://www.28msec.com/modules/jdbc";
import module namespace credentials = "http://www.28msec.com/modules/credentials";

variable $stack := mongo:connect(credentials:credentials("MongoDB", "stackoverflow"));
variable $qa := mongo:connect(credentials:credentials("MongoDB", "qa"));
variable $users := jdbc:connect(credentials:credentials("JDBC", "users"));

for $answer in mongo:find($stack, "answers")
where exists($answer.owner)
let $id := $answer.owner.user_id
let $answer := copy $q := $answer
               modify delete json $q.owner
               return $q
return mongo:save($qa, "answers", {| $answer, { user_id: $id } |});

for $question in mongo:find($stack, "faq")
where exists($question.owner)
let $id := $question.owner.user_id
let $question := copy $q := $question
                 modify delete json $q.owner
                 return $q
return mongo:save($qa, "questions", {| $question, { user_id: $id } |});
