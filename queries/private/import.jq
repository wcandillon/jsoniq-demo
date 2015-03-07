import module namespace mongo = "http://www.28msec.com/modules/mongodb";
import module namespace jdbc = "http://www.28msec.com/modules/jdbc";
import module namespace credentials = "http://www.28msec.com/modules/credentials";

variable $stack := mongo:connect(credentials:credentials("MongoDB", "stackoverflow"));
variable $qa := mongo:connect(credentials:credentials("MongoDB", "qa"));
variable $users := jdbc:connect(credentials:credentials("JDBC", "users"));

(:
for $answer in mongo:find($stack, "answers")
where exists($answer.owner)
let $answer := copy $q := $answer
               modify delete json $q.owner
               return $q
return mongo:save($qa, "answers", $answer);
:)

(:
for $question in mongo:find($stack, "faq")
where exists($question.owner)
let $question := copy $q := $question
                 modify delete json $q.owner
                 return $q
return mongo:save($qa, "questions", $question);
:)
