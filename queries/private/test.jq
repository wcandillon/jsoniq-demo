import module namespace mongo = "http://www.28msec.com/modules/mongodb";
import module namespace jdbc = "http://www.28msec.com/modules/jdbc";
import module namespace credentials = "http://www.28msec.com/modules/credentials";

variable $stack := mongo:connect(credentials:credentials("MongoDB", "stackoverflow"));
variable $qa := mongo:connect(credentials:credentials("JDBC", "qa"));
variable $users := jdbc:connect(credentials:credentials("MongoDB", "users"));
